//
//  OrderHistoryViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-08.
//

import Foundation

class OrderHistoryViewModel: ObservableObject {
    @Published var orders: [Order]
    var email: String
    
    init(email: String) {
        self.email = email
        orders = CoreDataUtilities.fetchOrders(of: email)
    }
}
