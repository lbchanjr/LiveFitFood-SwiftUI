//
//  ShakeCounter.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-06.
//

import Foundation

protocol ShakeCounterDelegate {
    func processShake()
}

class ShakeCounter: ObservableObject {
    @Published var shakeCountdown: Int
    private var resetCount: Int
    
    init(count: Int) {
        self.shakeCountdown = count
        self.resetCount = count
        print("**ShakeCounter allocated**")
    }
    
    func resetShakeCountdown() {
        shakeCountdown = resetCount
    }
    
    
    deinit {
        print("ShakeCounter deallocated")
    }
}

extension ShakeCounter: ShakeCounterDelegate {
    func processShake() {
        shakeCountdown -= 1
    }
}
