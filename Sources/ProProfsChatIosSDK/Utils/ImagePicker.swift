//
//  ImagePicker.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 02/11/22.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    @Environment(\.presentationMode) private var presentationMode
       var sourceType: UIImagePickerController.SourceType = .photoLibrary
       @Binding var selectedImage: UIImage
    @Binding var imageExtension:String

       func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

           let imagePicker = UIImagePickerController()
           imagePicker.allowsEditing = false
           imagePicker.sourceType = sourceType
           imagePicker.delegate = context.coordinator

           return imagePicker
       }

       func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

       }

       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

           var parent: ImagePicker

           init(_ parent: ImagePicker) {
               self.parent = parent
           }

           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   parent.selectedImage = image
                   let url =  info[.imageURL] as! NSURL
                   let url_string = url.absoluteString.map { String($0)} ?? ""
                   let arr  = url_string.split(separator: ".")
                   parent.imageExtension = arr.last.map { String($0)} ?? ""
                  
               }

               parent.presentationMode.wrappedValue.dismiss()
           }

       }
}
