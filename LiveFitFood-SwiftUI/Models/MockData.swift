//
//  MockData.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-02.
//

import Foundation

class MealkitMockData {
    static let viewContext = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" ? PersistenceController.shared.container.viewContext: PersistenceController.preview.container.viewContext

    let mealkitMockData = Mealkit(context: viewContext)
    let meal = Meal(context: viewContext)
    
    init() {
        mealkitMockData.name = "Live Fit Food"
        mealkitMockData.desc = "A mock object used for SwiftUI Preview purposes"
        mealkitMockData.photo = "noimage"
        mealkitMockData.price = 97.50
        mealkitMockData.sku = "LFF12345"
        
        for i in 1...5 {
            meal.name = "Meal #\(i)"
            meal.photo = "noimage"
            meal.calories = 100*Double(i)
            mealkitMockData.addToMeals(meal)
        }
    }
    
    func getMealkit() -> Mealkit {
        return mealkitMockData
    }
}


