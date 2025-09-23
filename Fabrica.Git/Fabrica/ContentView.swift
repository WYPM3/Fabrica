//
//  ContentView.swift
//  Fabrica
//
//  Created by Mason Wyper on 20/8/2025.


import SwiftUI

struct ContentView: View
{
    @State private var selectedTab = 0
    @State private var showOnboarding = false
    
    // MARK: - Design System Colors
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            HomeView(settings: Settings(
                quality: "Standard",
                strength: "Medium", 
                speed: 50,
                support: "Auto",
                wall: "Standard",
                travel: "Standard",
                layerHeight: 200,
                infillDensity: 20,
                retractionDistance: 6,
                retractionSpeed: 45,
                retractionCount: 5,
                coasting: "Enabled",
                wiping: "Enabled"
            ))
            .tabItem
            {
                Image(systemName: "cube.transparent.fill")
                Text("Analysis")
            }
            .tag(0)
            
            SettingsView()
                .tabItem
                {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(1)
            
            HelpView()
                .tabItem
                {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Help")
                }
                .tag(2)
        }
        .accentColor(primaryBlue)
        .onAppear
        {
            // Check if this is first launch
            if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            {
                showOnboarding = true
            }
        }
        .sheet(isPresented: $showOnboarding)
        {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
}

#Preview
{
    ContentView()
}
