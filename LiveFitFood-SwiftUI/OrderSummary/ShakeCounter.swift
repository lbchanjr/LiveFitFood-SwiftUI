//
//  ShakeCounter.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-06.
//

import Foundation
import SwiftUI

protocol ShakeCounterDelegate {
    func processShake(for email: String) -> Int?
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
    
    func generateDiscount() -> Int {
        // Odds:
        // 5% chance of getting a 50% discount
        // 30% chance of getting a 10% discount
        // 65% chance of not getting any discounts
        let discountArray = [Int](repeating: 50, count: 5) + [Int](repeating: 10, count: 30) + [Int](repeating: 0, count: 65).shuffled()
        
        // get a random discount value from the shuffled discount array
        return discountArray[Int.random(in: 0...99)]
    }
    
    
    deinit {
        print("ShakeCounter deallocated")
    }
}

extension ShakeCounter: ShakeCounterDelegate {
    func processShake(for email: String) -> Int? {
        if shakeCountdown > 0 {
            let discount = generateDiscount()
            shakeCountdown -= 1
            
            // Check if user has won a coupon
            if discount != 0 {
                guard let user = CoreDataUtilities.fetchUsers(with: email).first else {
                    return nil
                }
                
                // Generate coupon based on discount
                CoreDataUtilities.generateCoupon(with: discount, for: user)
                return discount
                
            } else {
                // User did not get a coupon discount
                return 0
            }
            
        } else {
            return nil
        }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}
