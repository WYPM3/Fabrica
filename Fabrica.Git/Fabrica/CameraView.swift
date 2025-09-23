//
//  CameraView.swift
//  Fabrica
//
//  Created by Mason Wyper on 20/8/2025.
//

import Foundation
import SwiftUI
import UIKit
import Vision
import CoreML

struct CameraView: UIViewControllerRepresentable
{
    @Binding var image: UIImage?
    @Binding var detectedObjects: [DetectedObject]
    let classifier: ThreeDPrintingClassifier
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController
    {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate
    {
        let parent: CameraView
        
        init(_ parent: CameraView)
        {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            if let image = info[.originalImage] as? UIImage
            {
                parent.image = image
                
                parent.classifier.classifyImage(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
        {
            parent.dismiss()
        }
    }
}
