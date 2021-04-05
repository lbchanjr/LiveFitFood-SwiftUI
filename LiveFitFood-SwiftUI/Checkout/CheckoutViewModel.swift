//
//  CheckoutViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-03.
//

import Foundation

protocol CheckoutViewModelDelegate {
    func processOrder() -> Void
    
    func updateTipAmount(tipPercentage: Double) -> Double
    
    func updateCouponDiscountAmount(discount: Double) -> Double
    
}


class CheckoutViewModel: ObservableObject {
    @Published var coupons: [Coupon]
    var email: String
    @Published var mealkit: Mealkit
    @Published var tipAmount = 0.00
    @Published var tax: Double
    @Published var couponDiscount = 0.00
    
    init(email: String, mealkit: Mealkit) {
        self.email = email
        self.mealkit = mealkit
        self.tax = mealkit.price * 0.13
        
        coupons = (CoreDataUtilities.fetchUsers(with: self.email).first?.coupons?.allObjects as! [Coupon]).filter {!$0.isUsed}
        
//        print("Unused coupon count: \(coupons.count)")
//        for c in coupons {
//            print("Code: \(c.code), Discount: \(c.discount), isUsed: \(c.isUsed)")
//        }
    }
    
    
}

extension CheckoutViewModel: CheckoutViewModelDelegate {
    func updateTipAmount(tipPercentage: Double) -> Double {
        tipAmount = mealkit.price * tipPercentage
        return tipAmount
    }
    
    func updateCouponDiscountAmount(discount: Double) -> Double {
        couponDiscount = mealkit.price * discount
        return couponDiscount
    }
    
    func processOrder() {
        
    }
}

