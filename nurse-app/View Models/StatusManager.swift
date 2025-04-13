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
            
            return
        }

        //Create folder for each patient by their name
        let folderName = "\(patient.firstName)_\(patient.lastName)"
        // Set each file name to the time we take the photo
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ":", with: "-")

        let fileName = "\(timestamp).jpg"
        let storagePath = "\(folderName)/\(fileName)"

        let storageRef = Storage.storage().reference().child(storagePath)

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error Upload: \(error.localizedDescription)")
            } else {
                print("Upload: \(storagePath)")
            }
        }
       
        print("Patient: \(patient.firstName) \(patient.lastName)")

    }
}
