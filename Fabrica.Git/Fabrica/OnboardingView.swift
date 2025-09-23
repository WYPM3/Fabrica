//
//  OnboardingView.swift
//  Fabrica
//
//  Created by Mason Wyper on 10/9/2025.
//

import SwiftUI

struct OnboardingView: View
{
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    
    private let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    private let secondaryBlue = Color(red: 0.85, green: 0.92, blue: 1.0)
    private let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    private let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    let onboardingPages = [
        OnboardingPage(
            title: "Welcome to Fabrica",
            subtitle: "AI-Powered 3D Printing Assistant",
            description: "Analyze materials, optimize print settings, and get expert recommendations powered by advanced artificial intelligence.",
            icon: "cube.transparent.fill",
            color: Color(red: 0.2, green: 0.4, blue: 0.8)
        ),
        OnboardingPage(
            title: "Smart Material Detection",
            subtitle: "Identify Any Filament",
            description: "Simply take a photo and our AI will identify PLA, ABS, PETG, TPU, and other materials with high accuracy.",
            icon: "cube.fill",
            color: Color.purple
        ),
        OnboardingPage(
            title: "Optimized Print Settings",
            subtitle: "Perfect Settings Every Time",
            description: "Get customized temperature, speed, and quality settings tailored to your specific printer and material combination.",
            icon: "gearshape.fill",
            color: Color(red: 0.2, green: 0.7, blue: 0.3)
        ),
        OnboardingPage(
            title: "Quality Analysis",
            subtitle: "Improve Your Prints",
            description: "Detect layer adhesion issues, surface defects, and get actionable recommendations to fix printing problems.",
            icon: "magnifyingglass",
            color: Color(red: 1.0, green: 0.6, blue: 0.0)
        ),
        OnboardingPage(
            title: "Privacy First",
            subtitle: "Your Data Stays Safe",
            description: "All analysis happens securely. Your API key is stored locally, and no personal data is collected or shared.",
            icon: "lock.shield.fill",
            color: Color(red: 0.9, green: 0.2, blue: 0.2)
        )
    ]
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            // Skip button
            HStack
            {
                Spacer()
                Button("Skip")
                {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    isPresented = false
                }
                .font(.subheadline)
                .foregroundColor(textSecondary)
                .padding(.trailing, 20)
                .padding(.top, 20)
            }
            
            
            TabView(selection: $currentPage)
            {
                ForEach(0..<onboardingPages.count, id: \.self)
                {
                    index in
                    onboardingPageView(onboardingPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            
            HStack(spacing: 8)
            {
                ForEach(0..<onboardingPages.count, id: \.self)
                {
                    index in
                    Circle()
                        .fill(index == currentPage ? primaryBlue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.bottom, 30)
            
           
            HStack(spacing: 16)
            {
                if currentPage > 0
                {
                    Button("Previous")
                    {
                        withAnimation(.easeInOut(duration: 0.3))
                        {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(primaryBlue)
                    .controlSize(.large)
                }
                else
                {
                   
                    Button("Previous")
                    {
                        // Empty action
                    }
                    .buttonStyle(.bordered)
                    .tint(primaryBlue)
                    .controlSize(.large)
                    .opacity(0)
                    .disabled(true)
                }
                
                Spacer()
                
                Button(currentPage == onboardingPages.count - 1 ? "Get Started" : "Next")
                {
                    if currentPage == onboardingPages.count - 1
                    {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        isPresented = false
                    }
                    else
                    {
                        withAnimation(.easeInOut(duration: 0.3))
                        {
                            currentPage += 1
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(primaryBlue)
                .controlSize(.large)
                .shadow(color: primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    secondaryBlue.opacity(0.3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    @ViewBuilder
    private func onboardingPageView(_ page: OnboardingPage) -> some View
    {
        VStack(spacing: 40)
        {
            Spacer()
            
            // Icon with animated background
            ZStack
            {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(page.color)
            }
            .scaleEffect(currentPage == onboardingPages.firstIndex(where: { $0.id == page.id }) ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
            
            // Text content
            VStack(spacing: 16)
            {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(page.color)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingPage: Identifiable
{
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let color: Color
}

#Preview
{
    OnboardingView(isPresented: .constant(true))
}

