//
//  BaseModel.swift
//  AnyToolkit
//
//  Created by corpsele_n on 2026/2/10.
//

import Foundation

// MARK: - Base Model Protocol
/// 基础模型协议
@available(macOS 15.0, iOS 13.0, *)
public protocol BaseModelProtocol: Identifiable, Codable {
    var id: String { get set }
}

// MARK: - Default Implementation
@available(macOS 15.0, iOS 13.0, *)
public extension BaseModelProtocol {
    // 如果 JSON 里没有 id，可以自动用 UUID 生成，防止崩溃
    mutating func autoGenerateIdIfNeeded() {
        if id.isEmpty {
            id = UUID().uuidString
        }
    }
}
