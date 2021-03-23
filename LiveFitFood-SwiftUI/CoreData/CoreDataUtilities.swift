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

    
}
