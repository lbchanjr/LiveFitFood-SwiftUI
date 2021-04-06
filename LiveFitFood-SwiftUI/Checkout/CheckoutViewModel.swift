//
//  CheckoutViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-03.
//

import Foundation
import Combine

protocol CheckoutViewModelDelegate {
    func processOrder() -> Void
    
    func updateTipAmount(tipPercentage: Double) -> Double
    
    func updateCouponDiscountAmount(discount: Double) -> Double
    
}


class CheckoutViewModel: ObservableObject {
    @Published var coupons: [Coupon]
    var email: String
    @Published var mealkit: Mealkit
    @Published var tipAmount: Double
    @Published var tax: Double
    @Published var couponDiscount: Double
    var appliedCoupon: Coupon?
    @Published var total: Double
    
    private var disposables = Set<AnyCancellable>()
    
    init(email: String, mealkit: Mealkit) {
        self.email = email
        self.mealkit = mealkit
        tax = mealkit.price * 0.13
        tipAmount = 0.00
        couponDiscount = 0.00
        coupons = (CoreDataUtilities.fetchUsers(with: email).first?.coupons?.allObjects as! [Coupon]).filter {!$0.isUsed}
        total = 0
        
        calculateTotal()
        
        $tipAmount
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] _ in self?.calculateTotal()})
            .store(in: &disposables)
        
        $couponDiscount
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] _ in self?.calculateTotal()})
            .store(in: &disposables)
    }
    
    private func calculateTotal() {
        total = mealkit.price + tax - couponDiscount + tipAmount
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
        
        CoreDataUtilities.addOrderToDatabase(email: email, tip: tipAmount, total: total, appliedCoupon: appliedCoupon, item: mealkit)
    }
}

