//
//  PublicView.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//  Strategy

import SwiftUI

// MARK: Strategy
// -----------------------------
internal protocol PublicView {
    func getViewFrame() -> CGRect
}

internal struct PublicOneView: PublicView {
    func getViewFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 300))
    }
}

internal struct PublicTwoView: PublicView {
    func getViewFrame() -> CGRect {
        return CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100))
    }
}
//------------------------------------------

// MARK: Method
// ------------------- Fac Method

internal protocol View {}

internal struct LabelView: View {
    let text: String
}

internal struct ButtonView: View {
    let title: String
    let action: () -> Void
}

internal struct ImageView: View {
    let imageName: String
}

@available(iOS 13.0, *)
internal enum ViewFac {
    static func makeLabel(text: String) -> some View {
        LabelView(text: text)
    }
    static func makeButton(title: String, action: @escaping () -> Void) -> some View {
        ButtonView(title: title, action: action)
    }
    static func makeImage(imageName: String) -> some View {
        ImageView(imageName: imageName)
    }
}

// ------------------------------

// MARK: Abstract
// -------------------------Abstract

enum Theme {
    case light
    case dark
}

internal protocol Button {
    func paint()
}

internal protocol CheckBox {
    func paint()
}

internal struct LightButton: Button {
    func paint() { print("绘制亮色按钮") }
}

internal struct LightCheckBox: CheckBox {
    func paint() { print("绘制亮色复选框") }
}

internal struct DarkButton: Button {
    func paint() { print("绘制暗色按钮") }
}

internal struct DarkCheckBox: CheckBox {
    func paint() { print("绘制暗色复选框") }
}

internal protocol GUIFac {
    func createButton() -> Button
    func createCheckBox() -> CheckBox
}

internal struct LightFac: GUIFac {
    func createButton() -> Button {
        LightButton()
    }
    
    func createCheckBox() -> CheckBox {
        LightCheckBox()
    }
}

internal struct DarkFac: GUIFac {
    func createButton() -> Button {
        DarkButton()
    }
    
    func createCheckBox() -> CheckBox {
        DarkCheckBox()
    }
}

internal final class FacProvider {
    static func factory(for theme: Theme) -> GUIFac {
        switch theme {
        case .light: return LightFac()
        case .dark:  return DarkFac()
        }
    }
}


// ------------------------------


// MARK: Generic
// ------------------------------

internal protocol Component {
    init()
}

internal struct LabelComponent: Component {
    init() {}
}

internal struct ButtonComponent: Component {
    init() {}
}

internal final class ComponentFac {
    // 字典保存：字符串 -> “遵循 Initializable 的类型的元类型”
    private var registry: [String: any Component.Type] = [:]
    private var creators: [String: () -> Any] = [:]
    // 注册方法
    func register<T: Component>(_ type: T.Type, forKey name: String) {
        registry[name] = type
    }
    // 根据名字创建实例（这里只支持无参 init）
    func create(forKey: String) -> any Component {
        guard let type = registry[forKey] else {
            fatalError("没有注册类型：\(forKey)")
        }
        return type.init()
    }
    func make<T: Component>() -> T {
        return T()
    }
}


// ------------------------------
