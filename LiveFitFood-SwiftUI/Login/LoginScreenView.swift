//
//  LoginScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-18.
//

import SwiftUI
import CoreData

struct LoginScreenView: View {
    //@State var userLoggedIn = false
    @State var registerUser = false
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @EnvironmentObject var userStatus: UserStatus
                
    var body: some View {
        
        VStack(alignment: .leading) {
            HeaderView()
            
            Text("Email")
                .font(.subheadline)
                .padding(.top, registerUser ? 10 : 20)
                
            TextField("Enter email address", text: $loginViewModel.email)
                .textContentType(.emailAddress)
                .minimumScaleFactor(0.8)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .minimumScaleFactor(0.8)
                .background(Color(.secondarySystemBackground))
                .opacity(registerUser ? 0.5: 1)
                .disabled(registerUser)
            
            PasswordPromptView(registerUser: $registerUser, textLabel: .constant("Password"), passwordPlaceholder: .constant("Enter password"), passwordInput: $loginViewModel.password)
            
            if !registerUser {
                HStack {
                    Spacer()
                    Button("Sign-in / Sign-up") {
                        signInButtonPressed()
                    }
                    .font(.title2)
                    .padding(.all)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .opacity(loginViewModel.validEmail ? 1.0: 0.5)
                    .fullScreenCover(isPresented: $userStatus.isLoggedIn) {
//                        Button("Logout") {
//                            userLoggedIn.toggle()
//                        }
//                        .padding(10)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
                        loginViewModel.toWelcomeScreenView
                    }
                    .disabled(!loginViewModel.validEmail)
                    
                    Spacer()
                }
                .padding(.top, 30)
                Toggle("Save username and password?", isOn: $loginViewModel.saveLoginInfo)
                    .padding()
            } else {
                RegistrationScreenView(registerUser: $registerUser)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text(loginViewModel.message)
                    .foregroundColor(.red)
                    .padding(.bottom)
                    .font(.headline)
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    
    private func signInButtonPressed() {
        switch(loginViewModel.processLogin()) {
        case .loginOK:
            userStatus.isLoggedIn.toggle()
        case .newUser:
            registerUser = true
        
        default:
            print("Login result: \(loginViewModel.processLogin())")
        }
        
        
    }
    
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoginViewModel(userSettings: UserSettings()))
        LoginScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoginViewModel(userSettings: UserSettings()))
            .environmentObject(UserStatus())
            //.colorScheme(.dark)
            //.background(Color.black)
            .previewDevice("iPhone SE (2nd generation)")
    }
}


