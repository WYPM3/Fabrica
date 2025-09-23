//
//  SettingsView.swift
//  Fabrica
//
//  Created by Mason Wyper on 10/9/2025.
//

import SwiftUI

struct SettingsView: View
{
    @State private var apiKey = ""
    @State private var analysisQuality = "High"
    @State private var enableHaptics = true
    @State private var enableNotifications = true
    @State private var showApiKeyInfo = false
    
    
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let secondaryBlue = Color(red: 0.85, green: 0.92, blue: 1.0)
    private let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    private let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    private let neutralGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    private let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    let qualityOptions = ["High", "Standard", "Fast"]
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(spacing: 24)
                {
                    apiConfigurationSection
                   
                    analysisSettingsSection
                    
                    appPreferencesSection
    
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .background(neutralGray.ignoresSafeArea())
        }
        .sheet(isPresented: $showApiKeyInfo)
        {
            ApiKeyInfoView(isPresented: $showApiKeyInfo)
        }
    }
    
    
    @ViewBuilder
    private var apiConfigurationSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "key.fill")
                    .foregroundColor(primaryBlue)
                    .font(.title3)
                
                Text("API Configuration")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
                
                Button("Info")
                {
                    showApiKeyInfo = true
                }
                .font(.caption)
                .foregroundColor(primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 8)
            {
                Text("OpenAI API Key")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                SecureField("Enter your API key", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
                
                Text("Required for AI analysis. Your key is stored securely on device.")
                    .font(.caption)
                    .foregroundColor(textSecondary)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    
    @ViewBuilder
    private var analysisSettingsSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Color.purple)
                    .font(.title3)
                
                Text("Analysis Settings")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12)
            {
                Text("Analysis Quality")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                Picker("Quality", selection: $analysisQuality)
                {
                    ForEach(qualityOptions, id: \.self)
                    {
                        quality in
                        Text(quality).tag(quality)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack
                {
                    Text("Higher quality provides more detailed analysis but takes longer")
                        .font(.caption)
                        .foregroundColor(textSecondary)
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    
    @ViewBuilder
    private var appPreferencesSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(accentGreen)
                    .font(.title3)
                
                Text("App Preferences")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12)
            {
                HStack
                {
                    VStack(alignment: .leading, spacing: 2)
                    {
                        Text("Haptic Feedback")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(textPrimary)
                        
                        Text("Feel vibrations for button presses and actions")
                            .font(.caption)
                            .foregroundColor(textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $enableHaptics)
                        .labelsHidden()
                        .tint(primaryBlue)
                }
                
                Divider()
                
                HStack
                {
                    VStack(alignment: .leading, spacing: 2)
                    {
                        Text("Notifications")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(textPrimary)
                        
                        Text("Get notified when analysis completes")
                            .font(.caption)
                            .foregroundColor(textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $enableNotifications)
                        .labelsHidden()
                        .tint(primaryBlue)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    
    @ViewBuilder
    private var aboutSection: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack(spacing: 8)
            {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(primaryBlue)
                    .font(.title3)
                
                Text("About Fabrica")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8)
            {
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(textSecondary)
                
                Text("AI-Powered 3D Printing Assistant")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textPrimary)
                
                Text("Analyze materials, optimize print settings, and get expert recommendations powered by advanced AI.")
                    .font(.caption)
                    .foregroundColor(textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}


struct ApiKeyInfoView: View
{
    @Binding var isPresented: Bool
    
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(alignment: .leading, spacing: 20)
                {
                    VStack(spacing: 12)
                    {
                        Image(systemName: "key.fill")
                            .font(.largeTitle)
                            .foregroundColor(primaryBlue)
                        
                        Text("OpenAI API Key Setup")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(textPrimary)
                        
                        Text("Get advanced AI analysis for your 3D printing materials and objects")
                            .font(.subheadline)
                            .foregroundColor(textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16)
                    {
                        stepItem(
                            number: "1",
                            title: "Create OpenAI Account",
                            description: "Visit openai.com and create an account if you don't have one"
                        )
                        
                        stepItem(
                            number: "2",
                            title: "Generate API Key",
                            description: "Go to API section and create a new API key with GPT-4 Vision access"
                        )
                        
                        stepItem(
                            number: "3",
                            title: "Add to Fabrica",
                            description: "Copy the key and paste it in the Settings > API Configuration section"
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 8)
                    {
                        Text("Privacy & Security")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(textPrimary)
                        
                        Text("• Your API key is stored securely on your device only\n• Images are sent to OpenAI for analysis but not stored\n• No personal data is collected or shared")
                            .font(.subheadline)
                            .foregroundColor(textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("API Key Info")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { isPresented = false })
        }
    }
    
    @ViewBuilder
    private func stepItem(number: String, title: String, description: String) -> some View
    {
        HStack(alignment: .top, spacing: 12)
        {
            Text(number)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(primaryBlue)
                .clipShape(Circle())
            
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
        }
    }
}

#Preview
{
    SettingsView()
}
