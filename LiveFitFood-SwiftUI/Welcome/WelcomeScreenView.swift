//
//  WelcomeScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-30.
//

import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject var user: LoggedInUser
    
    var welcomeScreenViewModel: WelcomeScreenViewModel
    
    var body: some View {
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
                        .font(.title2)
                        .minimumScaleFactor(0.7)
                    Button("Logout", action: {})
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 5)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                        
                }.padding(.leading, 10)
            }
            
            Text("Choose a Meal Kit")
                .bold()
                .font(.title)
            
            NavigationView {
                List {
                
                }
                //.navigationTitle("Choose a Meal Kit")
            }
            
        }.padding(.horizontal)
    }
    
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView(welcomeScreenViewModel: WelcomeScreenViewModel())
            .environmentObject(LoggedInUser(email: "abcde@gmail.com", phone: "+1-234-567-8999", image: UIImage(systemName: "person.fill")))
    }
}
