//
//  APIs.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/4.
//

/// Get API Url
internal enum AIUrl {
    case bigModel
    case ollama
    
    /// Get Url From Enum
    static func getAIUrl(url: AIUrl) -> String {
        switch url {
        case bigModel:
            return "https://open.bigmodel.cn/api/paas/v4/chat/completions"
        case ollama:
            return "https://ollama.com/api/chat"
            
        }
    }
    
    
}
