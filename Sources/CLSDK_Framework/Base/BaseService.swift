//
//  BaseService.swift
//  AnyToolkit
//
//  Created by corpsele_n on 2026/2/10.
//

import Foundation
import Combine

// MARK: - Base Service
@available(macOS 15.0, iOS 13.0, *)
public protocol BaseServiceProtocol {
    /// 通用请求方法
    /// - Parameters:
    ///   - endpoint: API 地址
    ///   - parameters: 参数
    /// - Returns: Publisher
    func request<T: Decodable>(endpoint: String, parameters: [String: Any]?) -> AnyPublisher<T, Error>
}

// 模拟网络请求的具体实现
public class APIService: BaseServiceProtocol {
    
    @available(macOS 15.0, iOS 13.0, *)
    public func request<T: Decodable>(endpoint: String, parameters: [String: Any]?) -> AnyPublisher<T, Error> {
        // 实际项目中这里是 URLSession 的代码
        // 这里我们模拟网络延迟和返回数据
        return Future<T, Error> { promise in
            print("📡 API Request: \(endpoint)")
            
            // 模拟 1.5秒 网络延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                // 模拟一个简单的成功返回
                // 注意：这里为了演示简化了真实 JSON 解析，实际需使用 JSONDecoder
                // 如果 T 是数组，这里会 crash，因为强转失败，实际项目中需根据 endpoint 构造真实数据
                // 为了演示能跑通，我们在下层的 Repository 做数据构造，这里仅做骨架
                if let dict = parameters as? [String: String] {
                    // 这是一个 hack，仅为了让代码结构演示通过，不要在生产环境这样写
                    // 生产环境应 decode JSON
                }
                
                // 这里我们不直接返回 T，而是抛个错误让上层 Repository 去处理模拟数据，
                // 或者这里返回空。为了演示完整性，我们在 Repository 层模拟 "获取数据"。
                promise(.failure(NSError(domain: "Mock", code: 999, userInfo: nil)))
            }
        }
        .eraseToAnyPublisher()
    }
}
