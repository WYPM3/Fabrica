//
//  HelpView.swift
//  Fabrica
//
//  Created by Mason Wyper on 10/9/2025.
//

import SwiftUI

struct HelpView: View
{
    @State private var selectedFAQ: Int? = nil
    @State private var showTutorial = false
    
 
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let secondaryBlue = Color(red: 0.85, green: 0.92, blue: 1.0)
    private let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    private let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
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
                   
                    quickStartSection
                    
                    
                    featuresGuideSection
                    
                  
                    faqSection
                    
                    
                    supportSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Help & Support")
            .navigationBarTitleDisplayMode(.large)
            .background(neutralGray.ignoresSafeArea())
        }
        .sheet(isPresented: $showTutorial)
        {
            InteractiveTutorialView(isPresented: $showTutorial)
        }
    }
    
  
    @ViewBuilder
    private var quickStartSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(accentGreen)
                    .font(.title3)
                
                Text("Quick Start")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12)
            {
                quickStartItem(
                    icon: "printer.fill",
                    title: "1. Add Your Printer",
                    description: "Tap the + button to select your 3D printer model"
                )
                
                quickStartItem(
                    icon: "camera.fill",
                    title: "2. Take a Photo",
                    description: "Capture an image of your 3D print or material"
                )
                
                quickStartItem(
                    icon: "brain.head.profile",
                    title: "3. Get AI Analysis",
                    description: "Receive expert recommendations and settings"
                )
            }
            
            Button("Start Interactive Tutorial")
            {
                showTutorial = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(primaryBlue)
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func quickStartItem(icon: String, title: String, description: String) -> some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: icon)
                .foregroundColor(primaryBlue)
                .font(.title3)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2)
            {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(12)
        .background(neutralGray)
        .cornerRadius(8)
    }
    
    
    @ViewBuilder
    private var featuresGuideSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "list.bullet.rectangle.fill")
                    .foregroundColor(Color.purple)
                    .font(.title3)
                
                Text("Features Guide")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12)
            {
                featureItem(
                    icon: "cube.fill",
                    title: "Material Detection",
                    description: "Automatically identifies PLA, ABS, PETG, TPU, and other materials",
                    color: primaryBlue
                )
                
                featureItem(
                    icon: "gearshape.fill",
                    title: "Print Settings",
                    description: "Get optimized temperature, speed, and quality settings for your printer",
                    color: accentGreen
                )
                
                featureItem(
                    icon: "magnifyingglass",
                    title: "Quality Analysis",
                    description: "Detect layer adhesion issues, surface defects, and dimensional accuracy",
                    color: warningOrange
                )
                
                featureItem(
                    icon: "square.and.arrow.up",
                    title: "Share Results",
                    description: "Copy or share AI analysis results with your team or community",
                    color: Color.purple
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func featureItem(icon: String, title: String, description: String, color: Color) -> some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2)
            {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
    
    
    @ViewBuilder
    private var faqSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(primaryBlue)
                    .font(.title3)
                
                Text("Frequently Asked Questions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 8)
            {
                faqItem(
                    id: 0,
                    question: "Do I need an OpenAI API key?",
                    answer: "Yes, for full AI analysis you need an OpenAI API key with GPT-4 Vision access. The app includes basic object detection that works offline."
                )
                
                faqItem(
                    id: 1,
                    question: "Which printers are supported?",
                    answer: "Fabrica supports Bambu Lab A1, A1 mini, P1P, P1S, X1, X1 Carbon, and H2/H2D models. More printers will be added in future updates."
                )
                
                faqItem(
                    id: 2,
                    question: "How accurate is the material detection?",
                    answer: "AI analysis provides 85-95% accuracy for common materials like PLA, ABS, PETG, and TPU. Accuracy depends on lighting conditions and image quality."
                )
                
                faqItem(
                    id: 3,
                    question: "Is my data private?",
                    answer: "Yes, your API key is stored locally. Images are only sent to OpenAI for analysis and are not stored. No personal data is collected."
                )
                
                faqItem(
                    id: 4,
                    question: "Can I use this offline?",
                    answer: "Basic object detection works offline using iOS Vision framework. Full AI analysis requires internet connection and API key."
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func faqItem(id: Int, question: String, answer: String) -> some View
    {
        VStack(spacing: 0)
        {
            Button(action: { selectedFAQ = selectedFAQ == id ? nil : id })
            {
                HStack
                {
                    Text(question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: selectedFAQ == id ? "chevron.up" : "chevron.down")
                        .foregroundColor(primaryBlue)
                        .font(.caption)
                }
                .padding(12)
                .background(neutralGray)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
            
            if selectedFAQ == id
            {
                VStack(alignment: .leading, spacing: 8)
                {
                    Text(answer)
                        .font(.caption)
                        .foregroundColor(textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
                .background(Color.white)
                .cornerRadius(8)
                .padding(.top, 2)
            }
        }
    }
    
   
    @ViewBuilder
    private var supportSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "envelope.fill")
                    .foregroundColor(accentGreen)
                    .font(.title3)
                
                Text("Need More Help?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12)
            {
                supportItem(
                    icon: "message.fill",
                    title: "Contact Support",
                    description: "Get help with technical issues or feature requests",
                    action: "Send Email"
                )
                
                supportItem(
                    icon: "star.fill",
                    title: "Rate the App",
                    description: "Help us improve by leaving a review on the App Store",
                    action: "Rate App"
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func supportItem(icon: String, title: String, description: String, action: String) -> some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: icon)
                .foregroundColor(primaryBlue)
                .font(.title3)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4)
            {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            Button(action)
            {
                // Action implementation
            }
            .font(.caption)
            .buttonStyle(.bordered)
            .tint(primaryBlue)
        }
        .padding(12)
        .background(neutralGray)
        .cornerRadius(8)
    }
}

struct InteractiveTutorialView: View
{
    @Binding var isPresented: Bool
    @State private var currentStep = 0
    
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    let tutorialSteps = [
        TutorialStep(
            title: "Welcome to Fabrica",
            description: "Your AI-powered 3D printing assistant",
            icon: "cube.transparent.fill"
        ),
        TutorialStep(
            title: "Add Your Printer",
            description: "Start by selecting your 3D printer model from our supported list",
            icon: "printer.fill"
        ),
        TutorialStep(
            title: "Capture Images",
            description: "Take photos of your prints, materials, or failed prints for analysis",
            icon: "camera.fill"
        ),
        TutorialStep(
            title: "Get AI Insights",
            description: "Receive expert recommendations for settings, materials, and improvements",
            icon: "brain.head.profile"
        ),
        TutorialStep(
            title: "You're Ready!",
            description: "Start analyzing your 3D prints and optimize your printing workflow",
            icon: "checkmark.circle.fill"
        )
    ]
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            // Progress indicator
            HStack
            {
                ForEach(0..<tutorialSteps.count, id: \.self)
                {
                    index in
                    Circle()
                        .fill(index <= currentStep ? primaryBlue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentStep ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            Spacer()
            
            // Tutorial content
            VStack(spacing: 24)
            {
                Image(systemName: tutorialSteps[currentStep].icon)
                    .font(.system(size: 60))
                    .foregroundColor(primaryBlue)
                
                VStack(spacing: 12)
                {
                    Text(tutorialSteps[currentStep].title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(tutorialSteps[currentStep].description)
                        .font(.subheadline)
                        .foregroundColor(textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 16)
            {
                if currentStep > 0
                {
                    Button("Previous")
                    {
                        currentStep -= 1
                    }
                    .buttonStyle(.bordered)
                    .tint(primaryBlue)
                }
                
                Spacer()
                
                Button(currentStep == tutorialSteps.count - 1 ? "Get Started" : "Next")
                {
                    if currentStep == tutorialSteps.count - 1
                    {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        isPresented = false
                    }
                    else
                    {
                        currentStep += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(primaryBlue)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}

struct TutorialStep
{
    let title: String
    let description: String
    let icon: String
}

#Preview
{
    HelpView()
}

