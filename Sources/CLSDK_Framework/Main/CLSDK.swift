//
//  CLSDK.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//

import Foundation

public class CLSDK {
    
    public func outputModel() {
        let model = PublicModelAdapter(legacyModel: LegacyModel(id: "1", strTitle: "Title", strUrl: "url", subTitle: "subTitle"))
        print("model id = \(model.id), strTitle = \(model.title), strUrl = \(model.strUrl)")
    }
    
}
