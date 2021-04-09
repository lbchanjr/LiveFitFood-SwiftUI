//
//  OrderSummaryViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-07.
//

import Foundation

class OrderSummaryViewModel {
    
    static func isShakePhoneGameAllowed(for email: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateToday = dateFormatter.string(from: Date())
        
        // print("Date today is: \(dateToday)")
        guard let user = CoreDataUtilities.fetchUsers(with: email).first else {
            // No user with this email found, don't allow game to start
            return false
        }
        
        // Fetch any coupons for user that were won today
        let coupons = CoreDataUtilities.fetchCoupons(on: dateToday, for: user)
        
        if coupons.isEmpty {
            // No coupons were won today, allow user to play game
            return true
        } else {
            // User has received coupon(s), don't allow game to start until the next day
            return false
        }
    }
        
}
