//
//  RegistrationScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-21.
//

import SwiftUI

struct RegistrationScreenView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var phone: String = ""
    @State var confirmPassword: String = ""
    @Binding var registerUser: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("Confirm Password")
                .font(.headline)
                .padding(.top, 5)
            SecureField("Re-enter password", text: $confirmPassword)
                .padding(.all, 10)
                .background(Color(.secondarySystemBackground))
            
            Text("Phone number")
                .font(.headline)
                .padding(.top, 10)
                
            TextField("e.g. +1-416-555-6789", text: $phone)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding(.all, 10)
                .background(Color(.secondarySystemBackground))

            Text("Profile photo")
                .font(.headline)
                .padding(.top, 10)
            HStack {
                Spacer()
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.size.width * 0.3, height: UIScreen.main.bounds.size.width * 0.3)
                    .padding(.all, 5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.label)))
                    
                    
                    
                Spacer()
                VStack {
                    Button("Use Camera", action: {})
                        .padding(.all)
                        .frame(width: UIScreen.main.bounds.size.width * 0.4)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                    Button("Choose Photo", action: {})
                        .padding(.all)
                        .frame(width: UIScreen.main.bounds.size.width * 0.4)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }.padding(.trailing, 15)
                Spacer()
            }
            
            HStack {
                Spacer()
                Button("Register", action: {})
                    .padding(.all)
                    .frame(width: UIScreen.main.bounds.size.width * 0.5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                Spacer()
                
                Button("Cancel", action: {
                    registerUser.toggle()
                    loginViewModel.message = ""
                })
                    .padding(.all)
                    .frame(width: UIScreen.main.bounds.size.width * 0.3)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Spacer()
            }.padding(.horizontal)
        }
    }
}

struct RegistrationScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreenView(registerUser: .constant(true))
            .environmentObject(LoginViewModel())
    }
}
