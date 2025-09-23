//
//  ThreeDPrintingClassifier.swift
//  Fabrica
//
//  Created by Mason Wyper on 27/8/2025.
//

import Foundation
import Vision
import CoreML
import UIKit

class ThreeDPrintingClassifier: ObservableObject
{
    @Published var detectedObjects: [DetectedObject] = []
    @Published var isAnalyzing = false
    @Published var chatGPTResponse: String = ""
    @Published var errorMessage: String = ""
    
    private let printingCategories = [
        "3d_printer", "filament_spool", "printed_object", "print_bed",
        "extruder", "hotend", "build_plate", "support_material"
    ]
    
    func classifyImage(_ image: UIImage)
    {
        isAnalyzing = true
        detectedObjects = []
        chatGPTResponse = ""
        errorMessage = ""
        
        
        guard APIConfig.isConfigured else
        {
            errorMessage = APIConfig.apiKeyMissing
            isAnalyzing = false
            analyzeWithLocalVision(image)
            return
        }
        
       
        analyzeWithChatGPT(image) { [weak self] success in
            if !success
            {
                
                self?.analyzeWithLocalVision(image)
            }
            DispatchQueue.main.async
            {
                self?.isAnalyzing = false
            }
        }
    }
    
    
    private func analyzeWithChatGPT(_ image: UIImage, completion: @escaping (Bool) -> Void)
    {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else
        {
            DispatchQueue.main.async
            {
                self.errorMessage = "Failed to process image"
            }
            completion(false)
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        let prompt = """
        You are an expert 3D printing analyst. Analyze this image and provide comprehensive information about 3D printing materials, objects, and print quality.
        
        **ANALYSIS FOCUS:**
        
        1. **Material Identification:**
           - Identify specific filament/resin types (PLA, ABS, PETG, TPU, PC, Nylon, HIPS, ASA, PVA, etc.)
           - Analyze surface finish, color, and texture characteristics
           - Assess material properties (strength, flexibility, heat resistance)
        
        2. **Print Quality Assessment:**
           - Layer adhesion and consistency
           - Surface finish quality (rough, smooth, glossy)
           - Dimensional accuracy and tolerances
           - Identify defects: stringing, warping, layer separation, under-extrusion, over-extrusion
        
        3. **Technical Recommendations:**
           - Optimal print settings (nozzle temp, bed temp, print speed)
           - Infill density and pattern suggestions
           - Support structure requirements
           - Post-processing steps (sanding, acetone vapor, annealing)
        
        4. **Professional Insights:**
           - Suitable applications for this print quality
           - Potential improvements for better results
           - Safety considerations and handling instructions
           - Cost-effectiveness analysis
        
        **FORMAT:** Provide structured sections with bullet points. Be specific with temperatures, speeds, and technical parameters.
        """
        
        let requestBody: [String: Any] = [
            "model": APIConfig.openAIModel,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": APIConfig.maxTokens,
            "temperature": APIConfig.temperature
        ]
        
        guard let url = URL(string: APIConfig.openAIBaseURL) else
        {
            DispatchQueue.main.async
            {
                self.errorMessage = "Invalid API URL"
            }
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIConfig.OPENAI_API_KEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        }
        catch
        {
            DispatchQueue.main.async
            {
                self.errorMessage = "Request serialization failed"
            }
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request)
        { [weak self] data, response, error in
            DispatchQueue.main.async
            {
                if let error = error
                {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    completion(false)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse
                {
                    switch httpResponse.statusCode {
                    case 200:
                        break
                    case 401:
                        self?.errorMessage = "Invalid API key. Please check your OpenAI API key."
                        completion(false)
                        return
                    case 429:
                        self?.errorMessage = "Rate limit exceeded. Please try again later."
                        completion(false)
                        return
                    case 500...599:
                        self?.errorMessage = "OpenAI service error. Please try again later."
                        completion(false)
                        return
                    default:
                        self?.errorMessage = "Unexpected error: \(httpResponse.statusCode)"
                        completion(false)
                        return
                    }
                }
                
                guard let data = data else
                {
                    self?.errorMessage = "No data received"
                    completion(false)
                    return
                }
                
                do
                {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        
                        self?.chatGPTResponse = content
                        self?.parseChatGPTResponse(content)
                        completion(true)
                    }
                    else
                    {
                        self?.errorMessage = "Invalid response format"
                        completion(false)
                    }
                }
                catch
                {
                    self?.errorMessage = "Failed to parse response"
                    completion(false)
                }
            }
        }.resume()
    }
    
 
    private func parseChatGPTResponse(_ response: String)
    {
        var newObjects: [DetectedObject] = []
        
        
        let materials = ["PLA", "ABS", "PETG", "TPU", "PC", "Nylon", "Resin", "Filament", "ASA", "PVA", "HIPS"]
        
        for material in materials
        {
            if response.uppercased().contains(material)
            {
                let confidence = calculateConfidence(for: material, in: response)
                let object = DetectedObject(
                    name: material,
                    confidence: confidence,
                    boundingBox: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8)
                )
                newObjects.append(object)
            }
        }
        
        
        if response.lowercased().contains("3d printer") || response.lowercased().contains("printer")
        {
            newObjects.append(DetectedObject(
                name: "3D Printer",
                confidence: 0.9,
                boundingBox: CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            ))
        }
        
        if response.lowercased().contains("filament") || response.lowercased().contains("spool")
        {
            newObjects.append(DetectedObject(
                name: "Filament Spool",
                confidence: 0.85,
                boundingBox: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4)
            ))
        }
        
        if response.lowercased().contains("printed") || response.lowercased().contains("print")
        {
            newObjects.append(DetectedObject(
                name: "3D Printed Object",
                confidence: 0.8,
                boundingBox: CGRect(x: 0.4, y: 0.4, width: 0.2, height: 0.2)
            ))
        }
        
        detectedObjects = newObjects
    }
    
    private func calculateConfidence(for material: String, in response: String) -> Double
    {
        let materialCount = response.uppercased().components(separatedBy: material).count - 1
        let baseConfidence = 0.7
        let bonusConfidence = min(Double(materialCount) * 0.1, 0.3)
        return min(baseConfidence + bonusConfidence, 1.0)
    }
    
    
    private func analyzeWithLocalVision(_ image: UIImage)
    {
        guard let cgImage = image.cgImage else
        {
            return
        }
        
        let request = VNClassifyImageRequest { [weak self] request, error in
            if let error = error
            {
                print("Image classification error: \(error)")
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            
            DispatchQueue.main.async
            {
                self?.detectedObjects = results.compactMap
                {
                    observation in
                    let objectName = observation.identifier.lowercased()
                    if self?.isPrintingRelated(objectName) == true
                    {
                        return DetectedObject(
                            name: self?.getFriendlyName(for: objectName) ?? objectName,
                            confidence: Double(observation.confidence),
                            boundingBox: CGRect(x: 0, y: 0, width: 1, height: 1)
                        )
                    }
                    return nil
                }
            }
        }
        
        request.usesCPUOnly = false
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        
        do
        {
            try handler.perform([request])
        }
        catch
        {
            print("Failed to perform image classification: \(error)")
        }
    }
    
    private func isPrintingRelated(_ objectName: String) -> Bool
    {
        return printingCategories.contains
        {
            category in
            objectName.contains(category) ||
            objectName.contains("printer") ||
            objectName.contains("print") ||
            objectName.contains("filament") ||
            objectName.contains("extruder")
        }
    }
    
    private func getFriendlyName(for objectName: String) -> String
    {
        let friendlyNames: [String: String] = [
            "3d_printer": "3D Printer",
            "filament_spool": "Filament Spool",
            "printed_object": "3D Printed Object",
            "print_bed": "Print Bed",
            "extruder": "Extruder",
            "hotend": "Hotend",
            "build_plate": "Build Plate",
            "support_material": "Support Material"
        ]
        
        return friendlyNames[objectName] ?? objectName.capitalized
    }
}
