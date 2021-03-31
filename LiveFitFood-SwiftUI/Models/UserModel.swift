//
//  UserModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-30.
//

import Foundation
import SwiftUI

class LoggedInUser: ObservableObject {
    let email: String
    let phone: String
    let image: UIImage?
  
    init(email: String, phone: String, image: UIImage?) {
        self.email = email
        self.phone = phone
        self.image = image
    }
}

class UserStatus: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
