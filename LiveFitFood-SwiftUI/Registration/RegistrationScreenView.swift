//
//  RegistrationScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-21.
//

import SwiftUI
import AVFoundation

struct RegistrationScreenView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Binding var registerUser: Bool
    @State var showCameraImagePicker = false
    @State var showPhotoLibraryImagePicker = false
    @State var cameraNotAllowedAlert = false
    var body: some View {
        VStack(alignment: .leading) {            
            PasswordPromptView(registerUser: $registerUser, textLabel: .constant("Confirm Password"), passwordPlaceholder: .constant("Re-enter password"), passwordInput: $loginViewModel.confirmPassword)

            Text("Phone number")
                .font(.subheadline)
                .padding(.top, 10)
                
            TextField("e.g. +1-416-555-6789", text: $loginViewModel.phone)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .minimumScaleFactor(0.8)
                .background(Color(.secondarySystemBackground))

            Text("Profile photo")
                .font(.subheadline)
                .padding(.top, 10)
            HStack {
                Spacer()
                Image(uiImage: loginViewModel.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(minWidth: UIScreen.main.bounds.size.width * 0.25, maxWidth: UIScreen.main.bounds.size.width * 0.3)
                    
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.label)).aspectRatio(1, contentMode: .fit))
                    
                Spacer()
                VStack {
                    Button("Use Camera", action: {
                        let camPermission = UIApplication.getCameraPermission()
                        if camPermission == AVAuthorizationStatus.authorized {
                            showCameraImagePicker.toggle()
                        } else if camPermission == AVAuthorizationStatus.denied {
                            cameraNotAllowedAlert.toggle()
                        }
                    })
                        .padding(.all, 10)
                        .frame(width: UIScreen.main.bounds.size.width * 0.4)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                        .opacity(UIImagePickerController.isSourceTypeAvailable(.camera) ? 1: 0.5)
                        .fullScreenCover(isPresented: $showCameraImagePicker, content: {
                            loginViewModel.photoFromCameraView
                        })
                        .alert(isPresented: $cameraNotAllowedAlert, content: {
                            Alert(title: Text("Camera permission is disabled"), message: Text("Go to application settings and enable Camera permission"), primaryButton: .default(Text("Go to settings"), action: {UIApplication.goToAppSettings()}), secondaryButton: .default(Text("No thanks")))
                        })
                    Button("Choose Photo", action: {showPhotoLibraryImagePicker.toggle()})
                        .padding(.all, 10)
                        .frame(width: UIScreen.main.bounds.size.width * 0.4)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
                        .opacity(UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ? 1: 0.5)
                        .fullScreenCover(isPresented: $showPhotoLibraryImagePicker, content: {
                            loginViewModel.photoFromLibraryView
                        })
                    
                }.padding(.trailing, 15)
                Spacer()
            }
            HStack {
                Spacer()
                Button("Register", action: {})
                    .padding(.all, 10)
                    .frame(width: UIScreen.main.bounds.size.width * 0.5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                Spacer()
                
                Button("Cancel", action: {
                    registerUser.toggle()
                    loginViewModel.resetRegistrationData()
                    loginViewModel.message = ""
                })
                    .padding(.all, 10)
                    .frame(width: UIScreen.main.bounds.size.width * 0.3)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Spacer()
            }.padding(.horizontal)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.hideKeyboard()
        }

    }
}

struct RegistrationScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreenView(registerUser: .constant(true))
            .environmentObject(LoginViewModel())
    }
}
