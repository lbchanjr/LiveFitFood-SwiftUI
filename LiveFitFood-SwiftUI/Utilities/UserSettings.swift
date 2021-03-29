//
//  UserSettings.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-28.
//

import Foundation

class UserSettings {
    var saveLoginData: Bool {
        didSet {
            if saveLoginData {
                UserDefaults.standard.set(email, forKey: "savedEmail")
                UserDefaults.standard.set(password, forKey: "savedPassword")
            }
            
            UserDefaults.standard.set(saveLoginData, forKey: "isLoginInfoSaved")
        }
    }
    
    var email: String = "" {
        didSet {
            if saveLoginData {
                UserDefaults.standard.set(email, forKey: "savedEmail")
            }
        }
    }
    
    var password: String = "" {
        didSet {
            if saveLoginData {
                UserDefaults.standard.set(password, forKey: "savedPassword")
            }
        }
    }
    
    init() {
        saveLoginData = (UserDefaults.standard.object(forKey: "isLoginInfoSaved") as? Bool) ?? false
        
        if saveLoginData {
            email = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
            password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
        }
    }
    
}
