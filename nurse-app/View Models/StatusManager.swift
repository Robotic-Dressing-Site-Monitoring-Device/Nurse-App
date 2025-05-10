//
//  StatusManager.swift
//  nurse-app
//
//  Created by Chris Tseng on 4/9/25.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit

class StatusManager: ObservableObject {

    @Published var remotePhotos: [RemotePhoto] = []

    func uploadImageToFirebase(patient: Patient, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image")
            return
        }

        let timestamp = Date()

        // Safe form to make sure the AI return back
        let idFormatter = ISO8601DateFormatter()
        idFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let safeTimestampID = idFormatter.string(from: timestamp)

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let displayString = displayFormatter.string(from: timestamp)

        let fileName = "\(displayString).jpg"
        let patientDocID = "\(patient.firstName.lowercased())_\(patient.lastName.lowercased())"
        let storagePath = "\(patientDocID)/\(fileName)"
        let storageRef = Storage.storage().reference().child(storagePath)

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploaded: \(error.localizedDescription)")
            } else {
                print(" Image uploaded: \(storagePath)")

                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Failed to get URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        let db = Firestore.firestore()

                        db.collection("patients")
                            .document(patientDocID)
                            .setData([
                                "firstName": patient.firstName,
                                "lastName": patient.lastName,
                                "location": patient.location
                            ], merge: true)

                        db.collection("patients")
                            .document(patientDocID)
                            .collection("photos")
                            .document(safeTimestampID)
                            .setData([
                                "imageURL": downloadURL.absoluteString,
                                "issue": ["unknown"],
                                "status": "pending",
                                "analyzed": false,
                                "time": Timestamp(date: timestamp),
                                "photoName": displayString,
                                "patient": "\(patient.firstName) \(patient.lastName)"
                            ], merge: true) { err in
                                if let err = err {
                                    print("Firestore write error: \(err)")
                                } else {
                                    print("Firestore write success")
                                }
                            }
                    }
                }
            }
        }
    }

    func fetchPhotos(for patient: Patient) {
        let patientDocID = "\(patient.firstName.lowercased())_\(patient.lastName.lowercased())"
        let db = Firestore.firestore()

        db.collection("patients")
            .document(patientDocID)
            .collection("photos")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching photos: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.remotePhotos = documents.compactMap { doc in
                        let data = doc.data()

                        guard data["analyzed"] as? Bool == true else {
                            print("⏳ Skipping un-analyzed photo: \(doc.documentID)")
                            return nil
                        }

                        guard let imageURL = data["imageURL"] as? String else {
                            print("Missing imageURL in doc: \(doc.documentID)")
                            return nil
                        }

                        let issues = data["issue"] as? [String] ?? []
                        let status = data["status"] as? String ?? "pending"
                        let timestamp = data["time"] as? Timestamp ?? Timestamp(date: Date())
                        let patientName = data["patient"] as? String ?? "unknown"

                        return RemotePhoto(
                            id: doc.documentID,
                            imageURL: imageURL,
                            issue: issues,
                            status: status,
                            time: timestamp.dateValue(),
                            patientName: patientName
                        )
                    }
                }
            }
    }
}
