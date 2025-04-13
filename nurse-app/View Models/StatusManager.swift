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
    
    func uploadImageToFirebase(patient: Patient, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print(" Failed to convert image to JPEG")
            return
        }
        
        let folderName = "\(patient.firstName)_\(patient.lastName)"
        let timestampString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ":", with: "-")
        
        let fileName = "\(timestampString).jpg"
        let storagePath = "\(folderName)/\(fileName)"
        let storageRef = Storage.storage().reference().child(storagePath)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading: \(error.localizedDescription)")
            } else {
                print("Image uploaded Success: \(storagePath)")
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Failed to get URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        let db = Firestore.firestore()
                        
                        db.collection(folderName).document(timestampString).setData([
                            "imageURL": downloadURL.absoluteString,
                            "issue": "unknown",
                            "patient": "\(patient.firstName) \(patient.lastName)",
                            "status": "pending",
                            "time": Timestamp(date: Date())
                        ], merge: true) { err in
                            if let err = err {
                                print("Firestore write error: \(err)")
                            } else {
                                print("Firestore Success")
                            }
                        }
                    }
                }
            }
        }
        
    }
}
