//
//  AIContentModel.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/5.
//

import Foundation

/// AI Content
internal struct AIContentModel {
    var id: String
    var ask: String
    var reply: String
    var source: String
}


final class AIContentModelAdapter: PublicModel {
    var aiContentModel: AIContentModel
    
    init(aiContentModel: AIContentModel) {
        self.aiContentModel = aiContentModel
    }
    
    var id: String {
        get {
            aiContentModel.id
        }
        set {
            aiContentModel.id = newValue
        }
    }
    
    var title: String { "" }
    
    var strUrl: String { "" }
    
    
}
