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

        let patientDocID = "\(patient.firstName.lowercased())_\(patient.lastName.lowercased())"
        let timestampString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ":", with: "-")

        let fileName = "\(timestampString).jpg"
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
                            .document(timestampString)
                            .setData([
                                "imageURL": downloadURL.absoluteString,
                                "issue": "unknown",
                                "status": "pending",
                                "time": Timestamp(date: Date()),
                                "patient": "\(patient.firstName) \(patient.lastName)"
                            ], merge: true) { err in
                                if let err = err {
                                    print(" Firestore write error: \(err)")
                                } else {
                                    print("PFierstore write success")
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
          .getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching photos: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            DispatchQueue.main.async {
                self.remotePhotos = documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let imageURL = data["imageURL"] as? String,
                        let issue = data["issue"] as? String,
                        let status = data["status"] as? String,
                        let timestamp = data["time"] as? Timestamp,
                        let patientName = data["patient"] as? String
                    else {
                        return nil
                    }

                    return RemotePhoto(
                        id: doc.documentID,
                        imageURL: imageURL,
                        issue: issue,
                        status: status,
                        time: timestamp.dateValue(),
                        patientName: patientName
                    )
                }
            }
        }
    }

}
