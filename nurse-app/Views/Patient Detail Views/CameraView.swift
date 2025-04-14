//
//  CameraView.swift
//  nurse-app
//
//  Created by Chris Tseng on 4/5/25.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    var onImagePicked: (UIImage) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
            if let image = info[.originalImage] as? UIImage {
                print("Image: \(image)")
                parent.onImagePicked(image)
            } else {
                print("Image Fail")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }


        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
