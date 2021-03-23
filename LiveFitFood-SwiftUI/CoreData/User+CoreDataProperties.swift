//
//  User+CoreDataProperties.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var photo: Data?

}

extension User : Identifiable {

}
