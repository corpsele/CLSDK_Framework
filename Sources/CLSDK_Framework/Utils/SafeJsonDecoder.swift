//
//  SafeJsonDecoder.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/23.
//

import Foundation

// MARK: - 核心工具扩展
extension KeyedDecodingContainer {
    
    /// 安全解码非可选属性
    /// - 兼容 Key 不存在 -> 返回默认值
    /// - 兼容 值为 null -> 返回默认值
    /// - 兼容 类型不匹配 -> 返回默认值
    /// - Parameters:
    ///   - type: 数据类型 (如 String.self, Int.self)
    ///   - key: CodingKey
    ///   - defaultValue: 解码失败时的默认值
    /// - Returns: 解码成功的值 或 默认值
    public func decode<T: Decodable>(_ type: T.Type, forKey key: Key, defaultValue: T) -> T {
        // try? 会捕获所有 throwing 错误，包括：
        // 1. keyNotFound (Key不存在)
        // 2. typeMismatch (类型不匹配)
        // 3. valueNotFound (值为null，且T不是Optional)
        return (try? decode(type, forKey: key)) ?? defaultValue
    }
    
    /// 安全解码可选属性
    /// - 兼容 Key 不存在 -> 返回 nil
    /// - 兼容 值为 null -> 返回 nil
    /// - 兼容 类型不匹配 -> 返回 nil (标准 decodeIfPresent 遇到类型不匹配会崩溃，这里修复了它)
    /// - Parameters:
    ///   - type: 数据类型 (如 String.self)
    ///   - key: CodingKey
    /// - Returns: 解码成功的 Optional 值 或 nil
    public func safeDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        // 标准 decodeIfPresent 已经处理了 Key缺失 和 Null
        // 但如果 Key 存在且非 Null，但类型不匹配，标准方法会 throw
        // 使用 try? 捕获类型不匹配的错误，返回 nil
        return try? decodeIfPresent(T.self, forKey: key)
    }
}

// 定义一个协议，让类型自己提供默认值
protocol Defaultable {
    static var defaultValue: Self { get }
}

// 给常用类型扩展默认值
extension Int: Defaultable { static let defaultValue = 0 }
extension String: Defaultable { static let defaultValue = "" }
extension Double: Defaultable { static let defaultValue = 0.0 }
extension Bool: Defaultable { static let defaultValue = false }
// 数组等类型
extension Array: Defaultable where Element: Defaultable {
    static var defaultValue: [Element] { [] }
}

// MARK: - 便捷属性包装器
/// 属性包装器，用于快速定义带默认值的属性，减少样板代码
@propertyWrapper
struct SafeDecodable<T: Decodable & Defaultable>: Decodable {
    var wrappedValue: T
    private var defaultValue: T = T.defaultValue
    
    init(wrappedValue: T, _ defaultValue: T) {
        self.wrappedValue = wrappedValue
        self.defaultValue = defaultValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // 尝试解码，失败则使用默认值
        if let value = try? container.decode(T.self) {
            wrappedValue = value
        } else {
            wrappedValue = defaultValue
        }
        
    }
}
