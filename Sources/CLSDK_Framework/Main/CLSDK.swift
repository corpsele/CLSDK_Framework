//
//  CLSDK.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//

import Foundation

public class CLSDK {
    
    private init() {
        
    }
    
    @MainActor public static let shared = CLSDK()
    
    public static func outputModel() {
        let model = PublicModelAdapter(legacyModel: LegacyModel(id: "1", strTitle: "Title", strUrl: "url", subTitle: "subTitle"))
        print("model id = \(model.id), strTitle = \(model.title), strUrl = \(model.strUrl)")
    }
    
    public func outputViewRect() {
        let rectOne = PublicOneView()
        let rectTwo = PublicTwoView()
        print("rectOne = \(rectOne.getViewFrame()), rectTwo = \(rectTwo.getViewFrame())")
    }
    
    
}

extension CLSDK {
    
    public func outputBroadcast() {
        let broadcast = Broadcast()
        let station = Station(identifier: "station1")
        broadcast.addObserver(station)
        broadcast.count = 55
        
    }
}

private class Station: PublicObserver {
    var identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func update(count: Double) {
        // print
        print("broadcast station id = \(identifier) count = \(count)")
    }
    
}
