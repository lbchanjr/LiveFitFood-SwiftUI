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
            // fetch all coupons in database
            coupons = try viewContext.fetch(requestCoupons)
        } catch {
            print("Error reading coupons from database")
            fatalError(error.localizedDescription)
        }
        
        return coupons
    }
    
    static func fetchCoupons(on date: String, for user: User) -> [Coupon] {
        var coupons: [Coupon] = []
        let request : NSFetchRequest<Coupon> = Coupon.fetchRequest()
        
        // Query for coupons that were generated on specified date for the logged user
        let query = NSPredicate(format: "dateGenerated == %@ AND owner == %@", date, user)
        request.predicate = query
        
        do {
            // fetch coupons with today's date for the specified user
            coupons = try viewContext.fetch(request)
        } catch {
            print("Error reading from database")
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
        
    static func addOrderToDatabase(order: Order, appliedCoupon: Coupon?) {
//        let order = Order(context: viewContext)
        order.datetime = Date()
        order.number = Int64(order.datetime!.hashValue)
//        order.buyer = fetchUsers(with: email).first
        order.discount = appliedCoupon
//        order.item = item
//        order.tip = tip
//        order.total = total
        
        if appliedCoupon != nil {
            appliedCoupon?.appliedTo = order
            appliedCoupon?.isUsed = true
            print("Coupon \(abs(appliedCoupon!.code)) applied to order")
        }
        
        do {
            try viewContext.save()
            print("Order saved to database")
        } catch {
            print("Error saving order!")
            print(error.localizedDescription)
        }
        
//        return order
    }
    
    static func createOrder(email: String, mealkit: Mealkit) -> Order {
        let order = Order(context: viewContext)
        order.buyer = fetchUsers(with: email).first
        order.item = mealkit
//        order.datetime = Date()
//        order.number = Int64(order.datetime!.hashValue)
//        order.discount = appliedCoupon
//        order.tip = tip
//        order.total = total

//        if appliedCoupon != nil {
//            appliedCoupon?.appliedTo = order
//            appliedCoupon?.isUsed = true
//        }

        return order
    }
    
    static func generateCoupon(with discount: Int, for user: User) {
        
        // Exit if discount is 0 (i.e. no need to generate a coupon)
        if discount == 0 {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateToday = dateFormatter.string(from: Date())
        
        let newCoupon = Coupon(context: viewContext)
        newCoupon.isUsed = false

        newCoupon.dateGenerated = dateToday
        newCoupon.discount = Double(discount)/100.0
        
        newCoupon.owner = user
        newCoupon.appliedTo = nil
        newCoupon.code = Int64(dateToday.hashValue)
        
        //print("Coupon code: \(String(format: "%010u", abs(newCoupon.code))), Discount: \(discount)%")
        do {
            try viewContext.save()
        } catch {
            print("Error saving coupon!")
            fatalError(error.localizedDescription)
        }
        
    }
    
    static func fetchOrders(of email: String) -> [Order] {
        var orders: [Order] = []
        let request : NSFetchRequest<Order> = Order.fetchRequest()
        
        guard let user = fetchUsers(with: email).first else {
            return orders
        }
        
        // Query for coupons that were generated on specified date
        let query = NSPredicate(format: "buyer == %@", user)
        request.predicate = query
        
        do {
            orders = try viewContext.fetch(request)
        } catch {
            print("Error reading from database")
            fatalError(error.localizedDescription)
        }
        
        return orders
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
