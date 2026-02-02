//
//  PublicView.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//  Strategy

import SwiftUI

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
