//
//  HomeView.swift
//  Fabrica
//
//  Created by Mason Wyper on 20/8/2025.
//

import SwiftUI
import PhotosUI

@MainActor
struct HomeView: View
{
    var settings : Settings
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showingCamera = false
    @State private var detectedObjects: [DetectedObject] = []
    @StateObject private var classifier = ThreeDPrintingClassifier()
    @State var showPrinters = false
    @State var createdProject = false
    @State var selectedPrinters = [String]()
    let printers = ["A1", "A1 mini", "P1P", "P1S", "X1", "X1 Carbon", "H2","H2D"]
    @State private var showMenu = false
    @State var selectedMaterial = ""
    @State private var materials = ["PLA", "PETG", "ABS", "TPU", "Nylon", "Polycarbonate", "ASA", "PVA"]
   
    @State var id = UUID()
    @State private var showClearConfirmation = false
    @State private var isImageLoading = false
    
    // MARK: - Design System Colors
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let secondaryBlue = Color(red: 0.85, green: 0.92, blue: 1.0)
    private let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    private let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    private let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    private let neutralGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    private let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(spacing: 24)
                {
                    
                    headerSection
                    
                    
                    if !selectedPrinters.isEmpty
                    {
                        printerConfigurationSection
                    }
                    
                    
                    VStack(spacing: 16)
                    {
                        imageSection
                        analysisStatusSection
                        errorSection
                        detectedObjectsSection
                        chatGPTAnalysisSection
                    }
                    
                    
                    actionButtonsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Fabrica")
            .navigationBarTitleDisplayMode(.large)
            .background(neutralGray.ignoresSafeArea())
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    addPrinterButton
                }
            }
            .sheet(isPresented: $showPrinters)
            {
                printerSelectionSheet
            }
            .alert("Clear Image?", isPresented: $showClearConfirmation)
            {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive)
                {
                    clearImage()
                }
            }
            message:
            {
                Text("This will remove the current image and analysis results. This action cannot be undone.")
            }
        }
    }
    
   
    @ViewBuilder
    private var headerSection: some View
    {
        VStack(spacing: 12)
        {
            HStack
            {
                Image(systemName: "cube.transparent.fill")
                    .font(.title2)
                    .foregroundColor(primaryBlue)
                
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("AI-Powered 3D Printing Assistant")
                        .font(.headline)
                        .foregroundColor(textPrimary)
                    
                    Text("Analyze materials and optimize print settings")
                        .font(.caption)
                        .foregroundColor(textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    
    @ViewBuilder
    private var printerConfigurationSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack
            {
                Image(systemName: "printer.fill")
                    .foregroundColor(primaryBlue)
                Text("Printer Configuration")
                    .font(.headline)
                    .foregroundColor(textPrimary)
                Spacer()
            }
            
            ForEach(selectedPrinters, id: \.self)
            {
                printerName in
                printerConfigurationCard(for: printerName)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
   
    @ViewBuilder
    private func printerConfigurationCard(for printerName: String) -> some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack
            {
                Image(systemName: "printer")
                    .foregroundColor(accentGreen)
                Text(printerName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8)
            {
                Text("Material Selection")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(textSecondary)
                
                Picker("Material", selection: $selectedMaterial)
                {
                    ForEach(materials, id: \.self)
                    {
                        material in
                        Text(material).tag(material)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(primaryBlue)
            }
            
            if selectedMaterial == "PLA"
            {
                printSettingsView
            }
            else if !selectedMaterial.isEmpty
            {
                Text("Select material to view optimized settings")
                    .font(.caption)
                    .foregroundColor(textSecondary)
                    .padding(.top, 8)
            }
        }
        .padding(12)
        .background(neutralGray)
        .cornerRadius(8)
    }
    
   
    @ViewBuilder
    private var printSettingsView: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text("Optimized Settings")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(textSecondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8)
            {
                settingItem("Quality", value: settings.quality)
                settingItem("Strength", value: settings.strength)
                settingItem("Speed", value: "\(settings.speed)%")
                settingItem("Support", value: settings.support)
            }
        }
        .padding(.top, 8)
    }
    
    
    @ViewBuilder
    private func settingItem(_ title: String, value: String) -> some View
    {
        VStack(alignment: .leading, spacing: 2)
        {
            Text(title)
                .font(.caption2)
                .foregroundColor(textSecondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
    }
    

    @ViewBuilder
    private var actionButtonsSection: some View
    {
        VStack(spacing: 12)
        {
            HStack(spacing: 12)
            {
                cameraButton
                photoPickerButton
            }
            
            if selectedImage != nil
            {
                clearImageButton
            }
        }
    }
    
    
    @ViewBuilder
    private var addPrinterButton: some View
    {
        Button(action: { showPrinters = true })
        {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundColor(primaryBlue)
        }
    }
    
    
    @ViewBuilder
    private var printerSelectionSheet: some View
    {
        NavigationView
        {
            VStack(spacing: 20)
            {
                VStack(spacing: 8)
                {
                    Image(systemName: "printer.fill")
                        .font(.largeTitle)
                        .foregroundColor(primaryBlue)
                    
                    Text("Select Your 3D Printer")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(textPrimary)
                    
                    Text("Choose one or more printers to configure")
                        .font(.subheadline)
                        .foregroundColor(textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                List(printers, id: \.self)
                {
                    printer in
                    printerSelectionRow(for: printer)
                }
                .listStyle(.insetGrouped)
                
                Button("Done")
                {
                    showPrinters = false
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom, 20)
            }
            .navigationTitle("Printers")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { showPrinters = false })
        }
    }
    
    
    @ViewBuilder
    private func printerSelectionRow(for printer: String) -> some View
    {
        Button
        {
            if selectedPrinters.contains(printer)
            {
                selectedPrinters.removeAll(where: { $0 == printer })
            }
            else
            {
                selectedPrinters.append(printer)
            }
        }
        label:
        {
            HStack(spacing: 12)
            {
                Image(systemName: selectedPrinters.contains(printer) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedPrinters.contains(printer) ? accentGreen : textSecondary)
                    .font(.title3)
                
                Text(printer)
                    .foregroundColor(textPrimary)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var imageSection: some View
    {
        if let selectedImage = selectedImage
        {
            VStack(alignment: .leading, spacing: 12)
            {
                HStack
                {
                    Image(systemName: "photo.fill")
                        .foregroundColor(primaryBlue)
                    Text("Image Analysis")
                        .font(.headline)
                        .foregroundColor(textPrimary)
                    Spacer()
                }
                
                ZStack
                {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    ForEach(detectedObjects)
                    {
                        object in
                        detectedObjectOverlay(for: object)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        else
        {
            VStack(spacing: 16)
            {
                Image(systemName: "camera.fill")
                    .font(.largeTitle)
                    .foregroundColor(textSecondary)
                
                VStack(spacing: 8)
                {
                    Text("No Image Selected")
                        .font(.headline)
                        .foregroundColor(textPrimary)
                    
                    Text("Take a photo or select from library to start AI analysis")
                        .font(.subheadline)
                        .foregroundColor(textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(40)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
   
    @ViewBuilder
    private var analysisStatusSection: some View
    {
        if classifier.isAnalyzing
        {
            HStack(spacing: 12)
            {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: primaryBlue))
                    .scaleEffect(1.0)
                
                VStack(alignment: .leading, spacing: 2)
                {
                    Text("Analyzing with AI")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(textPrimary)
                    
                    Text("Processing image and generating insights...")
                        .font(.caption)
                        .foregroundColor(textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(secondaryBlue)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(primaryBlue.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
   
    @ViewBuilder
    private var errorSection: some View
    {
        if !classifier.errorMessage.isEmpty
        {
            VStack(alignment: .leading, spacing: 12)
            {
                HStack(spacing: 8)
                {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(warningOrange)
                        .font(.title3)
                    
                    Text("Analysis Issue")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(textPrimary)
                    
                    Spacer()
                }
                
                Text(classifier.errorMessage)
                    .font(.subheadline)
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if classifier.errorMessage.contains("API key")
                {
                    Button("Configure API Key")
                    {
                        print("Open API configuration")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(primaryBlue)
                    .padding(.top, 4)
                }
            }
            .padding(16)
            .background(Color.orange.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(warningOrange.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    
    @ViewBuilder
    private func detectedObjectOverlay(for object: DetectedObject) -> some View
    {
        Rectangle()
            .stroke(Color.green, lineWidth: 2)
            .frame(
                width: object.boundingBox.width * 300,
                height: object.boundingBox.height * 300
            )
            .position(
                x: object.boundingBox.midX * 300,
                y: object.boundingBox.midY * 300
            )
    }
    
    
    @ViewBuilder
    private var detectedObjectsSection: some View
    {
        if !detectedObjects.isEmpty
        {
            VStack(alignment: .leading, spacing: 16)
            {
                HStack(spacing: 8)
                {
                    Image(systemName: "cube.fill")
                        .foregroundColor(primaryBlue)
                        .font(.title3)
                    
                    Text("Detected Materials & Objects")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(textPrimary)
                    
                    Spacer()
                    
                    Text("\(detectedObjects.count)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(neutralGray)
                        .cornerRadius(8)
                }
                
                LazyVStack(spacing: 8)
                {
                    ForEach(detectedObjects)
                    {
                        object in
                        detectedObjectRow(for: object)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    
    @ViewBuilder
    private func detectedObjectRow(for object: DetectedObject) -> some View
    {
        HStack(spacing: 12)
        {
            // Icon based on object type
            Group
            {
                if ["PLA", "ABS", "PETG", "TPU", "Nylon", "Resin", "ASA", "PVA", "HIPS"].contains(object.name.uppercased())
                {
                    Image(systemName: "cube.fill")
                        .foregroundColor(primaryBlue)
                }
                else
                {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(accentGreen)
                }
            }
            .font(.title3)
            .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4)
            {
                Text(object.name.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                HStack(spacing: 4)
                {
                    Text("Confidence:")
                        .font(.caption)
                        .foregroundColor(textSecondary)
                    
                    Text("\(Int(object.confidence * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(object.confidence > 0.8 ? accentGreen : (object.confidence > 0.6 ? warningOrange : errorRed))
                }
            }
            
            Spacer()
            
            // Confidence indicator
            ConfidenceIndicator(confidence: object.confidence)
        }
        .padding(12)
        .background(neutralGray)
        .cornerRadius(8)
    }
    
   
    @ViewBuilder
    private func ConfidenceIndicator(confidence: Double) -> some View
    {
        HStack(spacing: 2)
        {
            ForEach(0..<5, id: \.self)
            {
                index in
                Circle()
                    .fill(confidence > Double(index) * 0.2 ? (confidence > 0.8 ? accentGreen : (confidence > 0.6 ? warningOrange : primaryBlue)) : Color.gray.opacity(0.3))
                    .frame(width: 4, height: 4)
            }
        }
    }
    
    
    @ViewBuilder
    private var chatGPTAnalysisSection: some View
    {
        if !classifier.chatGPTResponse.isEmpty
        {
            VStack(alignment: .leading, spacing: 16)
            {
                HStack(spacing: 8)
                {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(Color.purple)
                        .font(.title3)
                    
                    Text("AI Analysis Results")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(accentGreen)
                        .font(.subheadline)
                }
                
                ScrollView
                {
                    Text(LocalizedStringKey(classifier.chatGPTResponse))
                        .font(.subheadline)
                        .foregroundColor(textPrimary)
                        .textSelection(.enabled)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                }
                .frame(maxHeight: 200)
                .padding(12)
                .background(neutralGray)
                .cornerRadius(8)
                
                HStack(spacing: 12)
                {
                    Button(action: copyAnalysis)
                    {
                        HStack(spacing: 6)
                        {
                            Image(systemName: "doc.on.doc")
                            Text("Copy")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                    .buttonStyle(.bordered)
                    .tint(primaryBlue)
                    
                    Button(action: shareAnalysis)
                    {
                        HStack(spacing: 6)
                        {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                    .buttonStyle(.bordered)
                    .tint(accentGreen)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var cameraButton: some View
    {
        Button(action: { showingCamera = true })
        {
            HStack(spacing: 8)
            {
                Image(systemName: "camera.fill")
                    .font(.subheadline)
                Text("Take Photo")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(isImageLoading || classifier.isAnalyzing ? primaryBlue.opacity(0.7) : primaryBlue)
            .cornerRadius(12)
            .shadow(color: primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(isImageLoading || classifier.isAnalyzing)
        .sheet(isPresented: $showingCamera)
        {
            CameraView(image: $selectedImage, detectedObjects: $detectedObjects, classifier: classifier)
        }
    }
    
    private var photoPickerButton: some View
    {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared())
        {
            HStack(spacing: 8)
            {
                if isImageLoading
                {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                else
                {
                    Image(systemName: "photo.fill")
                        .font(.subheadline)
                }
                
                Text(isImageLoading ? "Loading..." : "Select from Library")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(isImageLoading ? accentGreen.opacity(0.7) : accentGreen)
            .cornerRadius(12)
            .shadow(color: accentGreen.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(isImageLoading || classifier.isAnalyzing)
        .onChange(of: selectedItem)
        {
            _, newItem in
            handlePhotoSelection(newItem)
        }
    }
    
    private var clearImageButton: some View
    {
        Button(action: { showClearConfirmation = true })
        {
            HStack(spacing: 8)
            {
                Image(systemName: "trash.fill")
                    .font(.subheadline)
                Text("Clear Image")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(errorRed)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(errorRed.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private func handlePhotoSelection(_ newItem: PhotosPickerItem?)
    {
        guard let newItem = newItem else { return }
        
        isImageLoading = true
        
        Task
        {
            do
            {
                if let data = try await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data)
                {
                    await MainActor.run
                    {
                        selectedImage = image
                        detectedObjects = []
                        classifier.chatGPTResponse = ""
                        classifier.errorMessage = ""
                        isImageLoading = false
                        
                        // Add haptic feedback for successful image load
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        classifier.classifyImage(image)
                    }
                }
                else
                {
                    await MainActor.run
                    {
                        isImageLoading = false
                        classifier.errorMessage = "Unable to process the selected image. Please try a different image."
                    }
                }
            }
            catch
            {
                await MainActor.run
                {
                    isImageLoading = false
                    classifier.errorMessage = "Failed to load image: \(error.localizedDescription). Please check your photo library permissions and try again."
                }
            }
        }
    }
    
    private func clearImage()
    {
        selectedImage = nil
        detectedObjects = []
        classifier.chatGPTResponse = ""
        classifier.errorMessage = ""
        selectedItem = nil
        isImageLoading = false
        
        // Add haptic feedback for clear action
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func copyAnalysis()
    {
        UIPasteboard.general.string = classifier.chatGPTResponse
        // Could add haptic feedback here for better UX
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func shareAnalysis()
    {
        let activityVC = UIActivityViewController(
            activityItems: [classifier.chatGPTResponse],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first
        {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}
