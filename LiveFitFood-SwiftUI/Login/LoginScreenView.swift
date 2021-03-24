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
    @EnvironmentObject var loginViewModel: LoginViewModel
                
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
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .minimumScaleFactor(0.8)
                .background(Color(.secondarySystemBackground))
            
            Text("Password")
                .font(.subheadline)
                .padding(.top, registerUser ? 5 : 10)
            SecureField("Enter password", text: $loginViewModel.password)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .minimumScaleFactor(0.8)
                .background(Color(.secondarySystemBackground))
            
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
                RegistrationScreenView(registerUser: $registerUser)
            }
            
            if !registerUser {
                Spacer()
            }
            
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
        LoginScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoginViewModel())
        LoginScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoginViewModel())
            //.colorScheme(.dark)
            //.background(Color.black)
            .previewDevice("iPhone SE (2nd generation)")
    }
}


