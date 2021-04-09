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
    @EnvironmentObject var userStatus: UserStatus
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
                    .frame(minWidth: UIScreen.main.bounds.size.width * 0.25, maxWidth: UIScreen.main.bounds.size.width * 0.3)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(Rectangle().stroke(Color(.placeholderText), lineWidth: 3).aspectRatio(1, contentMode: .fit))
                    
                Spacer()
                VStack {
                    Button(action: {
                        let camPermission = UIApplication.getCameraPermission()
                        if camPermission == AVAuthorizationStatus.authorized {
                            showCameraImagePicker.toggle()
                        } else if camPermission == AVAuthorizationStatus.denied {
                            cameraNotAllowedAlert.toggle()
                        }
                    }) {
                        Text("Use Camera")
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.size.width * 0.4)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                        .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                        .opacity(UIImagePickerController.isSourceTypeAvailable(.camera) ? 1: 0.5)
                        .fullScreenCover(isPresented: $showCameraImagePicker, content: {
                            loginViewModel.photoFromCameraView
                        })
                        .alert(isPresented: $cameraNotAllowedAlert, content: {
                            Alert(title: Text("Camera permission is disabled"), message: Text("Go to application settings and enable Camera permission"), primaryButton: .default(Text("Go to settings"), action: {UIApplication.goToAppSettings()}), secondaryButton: .default(Text("No thanks")))
                        })
                    Button(action: {showPhotoLibraryImagePicker.toggle()}) {
                        Text("Choose Photo")
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.size.width * 0.4)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
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
                Button(action: {
                    loginViewModel.registerUser()
                    registerUser.toggle()
                    //userStatus.isLoggedIn.toggle()
                }) {
                    Text("Register")
                        .padding(.all, 10)
                        .frame(width: UIScreen.main.bounds.size.width * 0.5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                }
                    .opacity(loginViewModel.allowRegister ? 1: 0.5)
                    .disabled(!loginViewModel.allowRegister)
                    
                Spacer()
                
                Button(action: {
                    registerUser.toggle()
                    loginViewModel.resetRegistrationData()
                    loginViewModel.message = ""
                }) {
                    Text("Cancel")
                        .padding(.all, 10)
                        .frame(width: UIScreen.main.bounds.size.width * 0.3)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
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
            .environmentObject(LoginViewModel(userSettings: UserSettings()))
            .environmentObject(UserStatus())
    }
}
