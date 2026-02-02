//
//  PublicModel.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//  Adapter 

internal protocol PublicModel {
    var id: String {
        get
        set
    }
    var title: String { get }
    var strUrl: String { get }
}

internal struct LegacyModel {
    var id: String
    let strTitle: String
    let strUrl: String
    let subTitle: String
}

internal class PublicModelAdapter: PublicModel {
    
    var legacyModel: LegacyModel
    
    init(legacyModel: LegacyModel) {
        self.legacyModel = legacyModel
    }
    
    var id: String {
        get{
            legacyModel.id
        }
        set{
            legacyModel.id = newValue
        }
    }
    
    var title: String { "\(legacyModel.strTitle) \(legacyModel.subTitle)" }
    
    var strUrl: String { legacyModel.strUrl }
    
    
}
