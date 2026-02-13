//
//  BaseViewModel.swift
//  AnyToolkit
//
//  Created by corpsele_n on 2026/2/10.
//

import SwiftUI
import Combine

// MARK: - Base View Model
@available(macOS 15.0, iOS 13.0, *)
public class BaseViewModel: ObservableObject {
    
    // 加载状态
    @Published var isLoading: Bool = false
    // 错误信息
    @Published var errorMessage: String? = nil
    
    // 任何需要的订阅集合
    var cancellables = Set<AnyCancellable>()
    
    /// 显示错误提示
    func showError(_ message: String) {
        self.errorMessage = message
    }
    
    /// 开始加载
    func startLoading() {
        self.isLoading = true
        self.errorMessage = nil
    }
    
    /// 结束加载
    func stopLoading() {
        self.isLoading = false
    }
    
    /// 通用请求方法模拟
    @MainActor
    func fetchData<T: Decodable>(url: String, completion: @escaping (T?) -> Void) {
        // 实际项目中这里会是 Alamofire 或 URLSession
        startLoading()
        
        // 模拟网络延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.stopLoading()
            // 这里仅作模拟，实际应解析 JSON
            completion(nil)
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
