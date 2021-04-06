//
//  CoreDataUtilities.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-19.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataUtilities {
    static let viewContext = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" ? PersistenceController.shared.container.viewContext: PersistenceController.preview.container.viewContext
    
    static func fetchUsers(with email: String?) -> [User] {
        let request : NSFetchRequest<User> = User.fetchRequest()
        var users: [User] = []

        // Query for pokemons that are of different type compared to the selected pokemon
        if let email = email {
            let query = NSPredicate(format: "email == %@", email)
            request.predicate = query
        }

        do {
            // store sorted pokemons in the Pokemon array
            users = try viewContext.fetch(request)

        } catch {
            print("Error reading from database")
            print(error.localizedDescription)
        }
        return users
        
    }
    
    static func fetchMealkits() -> [Mealkit] {
        var mealkits: [Mealkit] = []
        let requestMealkits: NSFetchRequest<Mealkit> = Mealkit.fetchRequest()
        
        do {
            // store mealkits in array
            mealkits = try viewContext.fetch(requestMealkits)
        } catch {
            print("Error reading mealkits from database")
            fatalError(error.localizedDescription)
        }
        
        return mealkits
    }
    
    static func fetchMeals() -> [Meal] {
        var meals: [Meal] = []
        let requestMeals: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        do {
            // store meals in array
            meals = try viewContext.fetch(requestMeals)
        } catch {
            print("Error reading meals from database")
            fatalError(error.localizedDescription)
        }
        
        return meals
    }
    
    static func fetchCoupons() -> [Coupon] {
        var coupons: [Coupon] = []
        let requestCoupons: NSFetchRequest<Coupon> = Coupon.fetchRequest()
        
        do {
            // store meals in array
            coupons = try viewContext.fetch(requestCoupons)
        } catch {
            print("Error reading coupons from database")
            fatalError(error.localizedDescription)
        }
        
        return coupons
    }
    
    static func addUserToDatabase(email: String, password: String, phone: String, photo: UIImage ) {
        let user = User(context: viewContext)
        user.email = email
        user.password = password
        user.phone = phone
        user.photo = photo.pngData()
        
        // save data to database
        do {
            try viewContext.save()
        } catch {
            print("Error adding user to database")
        }
    }
    
    static func addOrderToDatabase(email: String, tip: Double, total: Double, appliedCoupon: Coupon?, item: Mealkit) {
        let order = Order(context: viewContext)
        order.datetime = Date()
        order.number = Int64(order.datetime!.hashValue)
        order.buyer = fetchUsers(with: email).first
        order.discount = appliedCoupon
        order.item = item
        order.tip = tip
        order.total = total
        
        if appliedCoupon != nil {
            appliedCoupon?.appliedTo = order
            appliedCoupon?.isUsed = true
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving order!")
            print(error.localizedDescription)
        }
    }

    static func loadJSONDataToSQLite() -> (mealkits: [Mealkit], meals: [Meal]) {
        var mealkits: [Mealkit] = []
        var meals: [Meal] = []
        
        print("Migrating JSON data to sqlite.")
        
        guard let file = Bundle.main.path(forResource:"mealkits", ofType:"json") else {
            print("Cannot find file")
            return (mealkits, meals)
        }
        
        do {
            guard let data = try String(contentsOfFile: file).data(using: .utf8) else {
                print("JSON file does not exist")
                return (mealkits, meals)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let results = try decoder.decode(LiveFitFoodData.self, from: data)
            
            //print("Decode json file: \n\(results)")
            
            mealkits = results.mealkits.map({ (mealkitData) -> Mealkit in
                let mealkit = Mealkit(context: viewContext)
                mealkit.name = mealkitData.kitName
                mealkit.desc = mealkitData.kitDesc
                mealkit.photo = mealkitData.photo
                mealkit.price = mealkitData.price
                mealkit.sku = mealkitData.sku
                
                _ = mealkitData.meals.map({ (mealData) -> Meal in
                    
                        let meal = Meal(context: viewContext)
                        meal.name = mealData.mealName
                        meal.calories = mealData.calories
                        meal.photo = mealData.photo

                        mealkit.addToMeals(meal)
                        meals.append(meal)
                        return meal
                })
                

                return mealkit

            })
            
            // Resolve duplicates by merging them into one
            viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            try viewContext.save()
            
        } catch {
            print("Error during json migration to sqlite")
            fatalError(error.localizedDescription)
        }
        
        return (mealkits, meals)
    }
}
