//
//  WelcomeScreenViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-30.
//

import Foundation

class WelcomeScreenViewModel: ObservableObject {
    @Published var mealkits: [Mealkit]
    @Published var meals: [Meal]
    
    init() {
        mealkits = CoreDataUtilities.fetchMealkits()
        meals = CoreDataUtilities.fetchMeals()
        print("mealkits found: \(mealkits.count)")
        if mealkits.count == 0 || meals.count == 0 {
            let liveFitFoodData = CoreDataUtilities.loadJSONDataToSQLite()
            mealkits = liveFitFoodData.mealkits
            meals = liveFitFoodData.meals
        }
        
        print("Welcome screen allocated")
    }
}
