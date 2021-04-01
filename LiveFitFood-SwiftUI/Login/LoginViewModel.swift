//
//  LoginViewModel.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-19.
//

import Foundation
import SwiftUI
import Combine
import CoreData

enum LoginResult {
    case loginOK, newUser, invalidPassword
}

protocol LoginViewModelDelegate {
    func resetRegistrationData()
    func registerUser()
    func processLogin() -> LoginResult
}

class LoginViewModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var confirmPassword = ""
    @Published var phone = ""
    @Published var message: String = ""
    @Published var image: UIImage = UIImage(named: "noimage")!
    @Published var validEmail = false
    @Published var allowRegister = false
    @Published var saveLoginInfo: Bool

    private var userSettings: UserSettings
    
    private var disposables = Set<AnyCancellable>()
        
    var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            //.dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {(self.isValidEmail($0) && !$0.isEmpty) || $0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    var isPasswordEmpty: AnyPublisher<Bool, Never> {
        $password
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    var isPasswordConfirmed: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .map {$0 == $1}
            .eraseToAnyPublisher()
    }
    
    init(userSettings: UserSettings) {
        
        self.userSettings = userSettings
        email = userSettings.email
        password = userSettings.password
        saveLoginInfo = userSettings.saveLoginData
        
        $email
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink {userSettings.email = $0}
            .store(in: &disposables)
        
        $password
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink {userSettings.password = $0}
            .store(in: &disposables)
        
        $saveLoginInfo
            .dropFirst()
            .sink {userSettings.saveLoginData = $0}
            .store(in: &disposables)
        
        isEmailValid
            .map {$0 ? "" : "Invalid email"}
            .assign(to: \.message, on: self)
            .store(in: &disposables)
        
        isEmailValid
          .receive(on: RunLoop.main)
          .map({$0 && !self.email.isEmpty})
          .assign(to: \.validEmail, on: self)
          .store(in: &disposables)
        
        Publishers.CombineLatest(isPasswordEmpty, isPasswordConfirmed)
            .map {!$0 && $1}
            .assign(to: \.allowRegister, on: self)
            .store(in: &disposables)
        
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

extension LoginViewModel: LoginViewModelDelegate {
    
    func resetRegistrationData() {
        if !saveLoginInfo {
            email = ""
            validEmail = false
            password = ""
        }
        confirmPassword = ""
        phone = ""
        message = ""
        image = UIImage(named: "noimage")!
    }
    
    func registerUser() {
        print("User will be registered")
        CoreDataUtilities.addUserToDatabase(email: email, password: password, phone: phone, photo: image)
        resetRegistrationData()
    }
    
    func processLogin() -> LoginResult {
        let users = CoreDataUtilities.fetchUsers(with: email)
        if let user = users.first {
            if user.password == password {
                message = ""
                if let photoData = user.photo {
                    image = UIImage(data: photoData) ?? UIImage(named: "noimage")!
                }
                
                return .loginOK
            } else {
                message = "Invalid password"
                return .invalidPassword
            }
        } else {
            
            message = "New user registration"
            return .newUser
        }
        
    }
}

// MARK: In the future, implement this using a view coordinator.
extension LoginViewModel {
    var photoFromCameraView: some View {
        return ImagePickerView(sourceType: .camera) { image in
            self.image = image
        }
    }
    
    var photoFromLibraryView: some View {
        return ImagePickerView(sourceType: .photoLibrary) { image in
            self.image = image
        }
    }
    
    var toWelcomeScreenView: some View {
        return WelcomeScreenView(welcomeScreenViewModel: WelcomeScreenViewModel())
            .environmentObject(LoggedInUser(email: email, phone: phone, image: image))
    }
}
