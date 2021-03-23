//
//  LoginScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-18.
//

import SwiftUI
import CoreData

struct LoginScreenView: View {
    @State var userLoggedIn = false
    @State var registerUser = false
    @ObservedObject var loginViewModel = LoginViewModel()
                
    var body: some View {
        
        VStack(alignment: .leading) {
            HeaderView()
            
            Text("Email")
                .font(.headline)
                .padding(.top, 20)
                
            TextField("Enter email address", text: $loginViewModel.email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding(.all, 10)
                .background(Color(.secondarySystemBackground))
            
            Text("Password")
                .font(.headline)
                .padding(.top, 10)
            SecureField("Enter password", text: $loginViewModel.password)
                .padding(.all, 10)
                .background(Color(.secondarySystemBackground))
//                .sheet(isPresented: $registerUser/*, onDismiss: {print("registerUser = \(registerUser)")}*/) {
//                    Button("Cancel") {
//                        registerUser.toggle()
//                    }
//                    .padding(10)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
            
            if !registerUser {
                HStack {
                    Spacer()
                    Button("Sign-in / Sign-up") {
                        signInButtonPressed()
                    }
                    .font(.title2)
                    .padding(15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .opacity(loginViewModel.validEmail ? 1.0: 0.5)
                    .fullScreenCover(isPresented: $userLoggedIn) {
                        Button("Logout") {
                            userLoggedIn.toggle()
                        }
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!loginViewModel.validEmail)
                    
                    Spacer()
                }
                .padding(.top, 30)
                
                
                Toggle("Save username and password?", isOn: $loginViewModel.saveLoginInfo)
                    .padding()
            } else {
                Text("Registration view goes here")
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text(loginViewModel.message)
                    .foregroundColor(.red)
                    .padding(.bottom)
                Spacer()
            }
            
        }
        .padding(.horizontal)
    }
    
    private func signInButtonPressed() {
        switch(loginViewModel.processLogin()) {
        case .loginOK:
            userLoggedIn.toggle()
        case .newUser:
            registerUser = true
        
        default:
            print("Login result: \(loginViewModel.processLogin())")
        }
        
        
    }
    
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


