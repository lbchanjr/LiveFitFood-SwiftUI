//
//  LoginScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-18.
//

import SwiftUI
import CoreData

struct LoginScreenView: View {
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
                LoginButtonViews(registerUser: $registerUser)
            } else {
                RegistrationScreenView(registerUser: $registerUser)
            }
            
            Spacer()
            
            LoginScreenMessage()
            
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoginViewModel(userSettings: UserSettings()))
            .environmentObject(UserStatus())
        LoginScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoginViewModel(userSettings: UserSettings()))
            .environmentObject(UserStatus())
            //.colorScheme(.dark)
            //.background(Color.black)
            .previewDevice("iPhone SE (2nd generation)")
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("livefitfood")
                    .resizable()
                    .scaledToFit()
                        .frame(minHeight: UIScreen.main.bounds.height * 0.1, maxHeight: UIScreen.main.bounds.height * 0.125)
                    .padding(.vertical)
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("Live Fit Mealkit Ordering App")
                    .font(.title3)
                Spacer()
            }
            .padding(.top, -15)
        }
    }
}

struct PasswordPromptView: View {
    @Binding var registerUser: Bool
    @Binding var textLabel: String
    @Binding var passwordPlaceholder: String
    @Binding var passwordInput: String
    
    var body: some View {
        VStack (alignment: .leading){
            Text(textLabel)
                .font(.subheadline)
                .padding(.top, registerUser ? 5 : 10)
                SecureField(passwordPlaceholder, text: $passwordInput)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .minimumScaleFactor(0.8)
                    .background(Color(.secondarySystemBackground))
        }
    }
}

struct LoginScreenMessage: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Text(loginViewModel.message)
                .foregroundColor(.red)
                .padding(.bottom)
                .font(.headline)
            Spacer()
        }
    }
}

struct LoginButtonViews: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var userStatus: UserStatus
    
    @Binding var registerUser: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    signInButtonPressed()
                }) {
                    Text("Sign-in / Sign-up")
                        .font(.title2)
                        .padding(.all)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .opacity(loginViewModel.validEmail ? 1.0: 0.5)
                .fullScreenCover(isPresented: $userStatus.isLoggedIn) {
                    loginViewModel.toWelcomeScreenView
                }
                .disabled(!loginViewModel.validEmail)
                
                Spacer()
            }
            .padding(.top, 30)
            Toggle("Save username and password?", isOn: $loginViewModel.saveLoginInfo)
                .padding()
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
