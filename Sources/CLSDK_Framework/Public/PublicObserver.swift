//
//  AppLiftCircle.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/2.
//  Observer

internal protocol PublicObserver: AnyObject {
    func update(count: Double)
}

internal protocol Subject: AnyObject {
    func addObserver(_ observer: PublicObserver)
    func removeObserver(_ observer: PublicObserver)
}

internal class Broadcast: Subject {
    var count: Double = 0 {
        didSet {
            modifyObserver()
        }
    }
    
    private var observers: [PublicObserver] = []
    
    internal func addObserver(_ observer: any PublicObserver) {
        if !observers.contains(where: { $0 === observer} ) {
            observers.append(observer)
        }
    }
    
    internal func removeObserver(_ observer: any PublicObserver) {
        observers.removeAll { $0 === observer}
    }
    
    internal func modifyObserver() {
        for observer in observers {
            observer.update(count: count)
        }
    }
}

internal class Station: PublicObserver {
    var identifier: String
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func update(count: Double) {
        
    }
    
}
