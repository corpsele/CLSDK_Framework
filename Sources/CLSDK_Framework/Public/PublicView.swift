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
