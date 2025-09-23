//
//  APIConfig.swift
//  Fabrica
//
//  Created by Mason Wyper on 28/8/2025.
//

import Foundation

struct APIConfig
{
   
    // Get your API key from: https://platform.openai.com/api-keys
    static let OPENAI_API_KEY = ProcessInfo.processInfo.environment[""] ?? ""
    
    
    static let openAIBaseURL = "https://api.openai.com/v1/chat/completions"
    static let openAIModel = "gpt-4o-mini"
    static let maxTokens = 1500
    static let temperature = 0.3
    
   
    static let chatCompletions = "/v1/chat/completions"
    
   
    static let apiKeyMissing = "OpenAI API key not configured. Please add your API key in APIConfig.swift"
    static let networkError = "Network error occurred. Please check your internet connection."
    static let apiError = "API error occurred. Please try again later."
    
    
    static var isConfigured: Bool
    {
        return !OPENAI_API_KEY.isEmpty && OPENAI_API_KEY.hasPrefix("sk-")
    }
    
    
    static let requestsPerMinute = 10
    static let requestsPerDay = 1000
}
