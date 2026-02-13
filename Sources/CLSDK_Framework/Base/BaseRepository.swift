//
//  BaseRepository.swift
//  AnyToolkit
//
//  Created by corpsele_n on 2026/2/10.
//

import Combine

// MARK: - Base Repository
@available(macOS 15.0, iOS 13.0, *)
public protocol BaseRepositoryProtocol {
    associatedtype Model: BaseModelProtocol
    associatedtype Service: BaseServiceProtocol
    
    var service: Service { get }
    
    /// 获取列表数据
    func fetchList() -> AnyPublisher<[Model], Error>
}

// 提供一个默认的实现骨架
@available(macOS 15.0, iOS 13.0, *)
public extension BaseRepositoryProtocol {
    // 实际项目中这里会调用 service.request(...).decode(...)
}
