//
//  CLSDK.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//

import Foundation
import Combine

public class CLSDK {
    
    private init() {
        
    }
    
    @MainActor public static let shared = CLSDK()
    
    public static func outputModel() {
        let model = PublicModelAdapter(legacyModel: LegacyModel(id: "1", strTitle: "Title", strUrl: "url", subTitle: "subTitle"))
        print("==========model id = \(model.id), strTitle = \(model.title), strUrl = \(model.strUrl)")
    }
    
    public func outputViewRect() {
        let rectOne = PublicOneView()
        let rectTwo = PublicTwoView()
        print("==========rectOne = \(rectOne.getViewFrame()), rectTwo = \(rectTwo.getViewFrame())")
    }
    
    
}

extension CLSDK {
    
    public func outputBroadcast() {
        let broadcast = Broadcast()
        let station = Station(identifier: "station1")
        broadcast.addObserver(station)
        broadcast.count = 55
        
    }
    
    
    @available(iOS 13.0, *)
    public func outputCombinObserver() {
        var cancellabel = Set<AnyCancellable>()
        let model = PublicObserverModel()
        model.increment()
        model.$counter.sink { newValue in
            print("==========outputCombinObserver counter = \(newValue)")
        }
        .store(in: &cancellabel)
    }
    
    public func outputSimpleFac() {
        let config = AppEnviroment.make(for: .dev)
        print("==========outputSimpleFac config = \(config.baseUrl), \(config.apiKey)")
    }
    
    @available(iOS 13.0, *)
    public func outputMethodFac() {
        let v = ViewFac.makeLabel(text: "label fac")
        print("==========outputMethodFac v = \(v)")
    }
    
    public func outputAbstractFac() {
        let fac = FacProvider.factory(for: .dark)
        let button = fac.createButton()
        let checkBox = fac.createCheckBox()
        button.paint()
        checkBox.paint()
    }
    
    public func outputGenericFac() {
        let fac = ComponentFac()
        let label: LabelComponent = fac.make()
        let button: ButtonComponent = fac.make()
        print("==========outputGenericFac label = \(label), button = \(button)")
        fac.register(LabelComponent.self, forKey: "label")
        fac.register(ButtonComponent.self, forKey: "button")
        let l: LabelComponent? = fac.create(forKey: "label")
        let b: ButtonComponent? = fac.create(forKey: "button")
        print("==========outputGenericFac l = \(l), b = \(b)")
    }
}

private class Station: PublicObserver {
    var identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func update(count: Double) {
        // print
        print("=========broadcast station id = \(identifier) count = \(count)")
    }
    
}
