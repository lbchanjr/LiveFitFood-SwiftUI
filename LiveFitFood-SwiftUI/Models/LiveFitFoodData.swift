//
//  LiveFitFoodData.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-30.
//

import Foundation

struct LiveFitFoodData: Codable, CustomStringConvertible {
    let mealkits: [MealKitData]

    var description: String {
        return mealkits.map{$0.description}.joined(separator: "\n")
    }
    
    struct MealKitData: Codable, CustomStringConvertible {
        let kitName: String
        let kitDesc: String
        let photo: String
        let price: Double
        let sku: String
        let meals: [MealData]
        
        var description: String {
            return "\(kitName) - \(kitDesc) with \(meals.count) meals"
        }
    }
    
    struct MealData: Codable, CustomStringConvertible {
        let mealName: String
        let calories: Double
        let photo: String
        
        var description: String {
            return "\(mealName) has \(calories) calories"
        }
    }
    
}
