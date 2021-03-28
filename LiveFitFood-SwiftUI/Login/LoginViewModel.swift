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
    func processLogin() -> LoginResult
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var phone = ""
    @Published var message: String = ""
    @Published var image: UIImage = UIImage(named: "noimage")!
    @Published var validEmail = false
    @Published var saveLoginInfo: Bool = false

    private var disposables = Set<AnyCancellable>()
        
    var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map {(self.isValidEmail($0) && !$0.isEmpty) || $0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    var isPasswordEmpty: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map {!$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    init() {
        
        isEmailValid
            .map {$0 ? "" : "Invalid email"}
            .assign(to: \.message, on: self)
            .store(in: &disposables)
        
        isEmailValid
          .receive(on: RunLoop.main)
          .map({$0 && !self.email.isEmpty})
          .assign(to: \.validEmail, on: self)
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
        email = ""
        password = ""
        confirmPassword = ""
        phone = ""
        message = ""
        image = UIImage(named: "noimage")!
        validEmail = false
    }
    
    func processLogin() -> LoginResult {
        let users = CoreDataUtilities.fetchUsers(with: email)
        if let user = users.first {
            if user.password == password {
                message = ""
                return .loginOK
            } else {
                print("user password: \(password)")
                message = "Invalid password"
                return .invalidPassword
            }
        } else {
            
            message = "New user registration"
            return .newUser
        }
        
    }
}

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
}
