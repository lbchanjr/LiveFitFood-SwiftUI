//
//  CheckoutViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-03.
//

import Foundation
import Combine

protocol CheckoutViewModelDelegate {
    func processOrder()
    
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
    @Published var order: Order
    
    static let decimalHandler = NSDecimalNumberHandler(roundingMode: .up, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
    
    private var disposables = Set<AnyCancellable>()
    
    init(email: String, mealkit: Mealkit) {
        self.email = email
        self.mealkit = mealkit
        
        tax = NSDecimalNumber(value: mealkit.price).multiplying(by: NSDecimalNumber(value: 0.13)).rounding(accordingToBehavior: CheckoutViewModel.decimalHandler).doubleValue
        
        tipAmount = 0.00
        couponDiscount = 0.00
        coupons = (CoreDataUtilities.fetchUsers(with: email).first?.coupons?.allObjects as! [Coupon]).filter {!$0.isUsed}
        total = 0
        order = CoreDataUtilities.createOrder(email: email, mealkit: mealkit)
               
        calculateTotal()
        
        $tipAmount
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] tip in
                self?.calculateTotal()
                self?.order.tip = tip
            })
            .store(in: &disposables)
        
        $couponDiscount
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] _ in
                self?.calculateTotal()
            })
            .store(in: &disposables)
        
        print("Checkout view model allocated")
    }
    
    private func calculateTotal() {
        total = mealkit.price + tax - couponDiscount + tipAmount
        order.total = total
    }
}

extension CheckoutViewModel: CheckoutViewModelDelegate {
    func updateTipAmount(tipPercentage: Double) -> Double {
        tipAmount = NSDecimalNumber(value: mealkit.price).multiplying(by: NSDecimalNumber(value: tipPercentage)).rounding(accordingToBehavior: CheckoutViewModel.decimalHandler).doubleValue
        return tipAmount
    }
    
    func updateCouponDiscountAmount(discount: Double) -> Double {
        couponDiscount = NSDecimalNumber(value: mealkit.price).multiplying(by: NSDecimalNumber(value: discount)).rounding(accordingToBehavior: CheckoutViewModel.decimalHandler).doubleValue
        return couponDiscount
    }
    
    func processOrder() {
//        return CoreDataUtilities.createOrder(email: email, tip: tipAmount, total: total, appliedCoupon: appliedCoupon, item: mealkit)
        CoreDataUtilities.addOrderToDatabase(order: order, appliedCoupon: appliedCoupon)
    }
}

