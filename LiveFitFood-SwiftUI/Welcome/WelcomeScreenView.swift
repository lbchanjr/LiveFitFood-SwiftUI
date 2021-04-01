//
//  WelcomeScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-30.
//

import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject var user: LoggedInUser
    @EnvironmentObject var userStatus: UserStatus
    var welcomeScreenViewModel: WelcomeScreenViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(uiImage: user.image ?? UIImage(named: "noimage")!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.height * 0.15, height: UIScreen.main.bounds.height * 0.15)
                        .scaledToFit()
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(.label)).aspectRatio(1, contentMode: .fit))
                    VStack(alignment: .leading) {
                        Text("Welcome!")
                            .font(.title)
                        Text(user.email)
                            .font(.title3)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        Button("Logout", action: {userStatus.isLoggedIn.toggle()})
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(.all, 5)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                        
                    }.padding(.leading, 10)
                }
                .padding(.horizontal)
                .padding(.top)
                
                Text("Choose a Meal Kit")
                    .bold()
                    .font(.title)
                
                
                List(welcomeScreenViewModel.mealkits) { mealkit in
                    NavigationLink(
                        destination: MealkitDetailsView(mealkit: mealkit)) {
                        HStack {
                            Image(mealkit.photo ?? "noimage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                            VStack(alignment: .leading) {
                                Text(mealkit.name ?? "")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Text(mealkit.desc ?? "")
                                    .font(.subheadline)
                                    .minimumScaleFactor(0.7)
                                Spacer()
                                Text(String(format: "CA$%.2f", mealkit.price))
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    
                }
                
                .navigationBarHidden(true)
                
                
                
                
            }
        }
    }
    
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView(welcomeScreenViewModel: WelcomeScreenViewModel())
            .environmentObject(LoggedInUser(email: "abcde@gmail.com", phone: "+1-234-567-8999", image: UIImage(systemName: "person.fill")))
            .environmentObject(UserStatus())
    }
}
