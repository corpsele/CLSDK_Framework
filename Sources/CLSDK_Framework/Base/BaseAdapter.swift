//
//  BaseAdapter.swift
//  AnyToolkit
//
//  Created by corpsele_n on 2026/2/10.
//

import SwiftUI

// MARK: - Base Adapter (Row View)
/// 列表项视图的基类协议
@available(macOS 15.0, iOS 13.0, *)
protocol BaseAdapterView: View {
    associatedtype Item: BaseModelProtocol
    var item: Item { get }
}

// 为了演示，提供一个通用的默认实现（如果子类不想自定义太复杂）
@available(macOS 15.0, iOS 13.0, *)
public struct DefaultRowView<Item: BaseModelProtocol>: View {
    let item: Item
    
    var body: View {
        HStack {
            Text("ID: \(item.id)")
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .background(Color.gray.opacity(0.1))
        .padding() as! View
        
    }
}
