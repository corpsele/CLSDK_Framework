//
//  PublicConfig.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//  Factory

import Foundation


// ----------------- simple
internal enum AppEnviroment {
    case dev
    case profile
    case production
    
    static func make(for enviroment: AppEnviroment) -> APIConfig {
        switch enviroment {
        case dev:
            return DevConfig()
        case profile:
            return ProfileConfig()
        case production:
            return ProductionConfig()
        }
    }
}


internal protocol APIConfig {
    var baseUrl: URL { get }
    var apiKey: String { get }
}

internal struct DevConfig: APIConfig {
    var baseUrl: URL { return URL(string: "https://www.baidu.com")! }
    var apiKey: String { return "dev-key" }
}

internal struct ProfileConfig: APIConfig {
    var baseUrl: URL { return URL(string: "https://www.bing.com")! }
    var apiKey: String { return "profile-key" }
}

internal struct ProductionConfig: APIConfig {
    var baseUrl: URL { return URL(string: "https://www.yandex.com")! }
    var apiKey: String { return "profile-key" }
}


// ------------------------
