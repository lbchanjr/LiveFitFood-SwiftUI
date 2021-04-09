//
//  WelcomeScreenView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-30.
//

import SwiftUI

struct WelcomeScreenView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var user: LoggedInUser
    @EnvironmentObject var userStatus: UserStatus
    var welcomeScreenViewModel: WelcomeScreenViewModel
    
    @State var isActive: [Bool] =  Array<Bool>(repeating: false, count: 4)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                WelcomeScreenHeaderView()
                
                Text("Choose a Meal Kit")
                    .bold()
                    .font(.title)
                    .padding(.leading)
                
                List(0..<welcomeScreenViewModel.mealkits.count) { i in
                    NavigationLink(
                        destination: MealkitDetailsView(isActive: $isActive[i]/*mealkit: mealkit*/)
                            .environmentObject(welcomeScreenViewModel.mealkits[i]), isActive: $isActive[i]
                    ) {
                        WelcomeScreenMealkitView(mealkit: welcomeScreenViewModel.mealkits[i])
                    }
                    
                }
                .navigationBarHidden(true)
                //.navigationBarTitle("Choose a Meal Kit")
            }
            //.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
    
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView(welcomeScreenViewModel: WelcomeScreenViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LoggedInUser(email: "abcde@gmail.com", phone: "+1-234-567-8999", image: UIImage(systemName: "person.fill")))
            .environmentObject(UserStatus())
    }
}

struct WelcomeScreenHeaderView: View {
    @EnvironmentObject var user: LoggedInUser
    @EnvironmentObject var userStatus: UserStatus
    
    var body: some View {
        HStack {
            Image(uiImage: user.image ?? UIImage(named: "noimage")!)
                .resizable()
                .frame(width: UIScreen.main.bounds.height * 0.15, height: UIScreen.main.bounds.height * 0.15)
                .scaledToFit()
                //.cornerRadius(15)
                .overlay(Rectangle().stroke(Color(.placeholderText), lineWidth: 3).aspectRatio(1, contentMode: .fit))
            VStack(alignment: .leading) {
                Text("Welcome!")
                    .font(.title)
                Text(user.email)
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Button(action: {userStatus.isLoggedIn.toggle()}) {
                    Text("Logout")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 5)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
                
            }.padding(.leading, 10)
        }
        .padding([.horizontal, .top])
    }
}

struct WelcomeScreenMealkitView: View {
    var mealkit: Mealkit
    
    var body: some View {
        HStack {
            Image(mealkit.photo ?? "noimage")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
            //.frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text(mealkit.name ?? "")
                    .font(.title2)
                    .bold()
                Text(mealkit.desc ?? "")
                    .font(.subheadline)
                    .minimumScaleFactor(0.7)
                Text(String(format: "CA$%.2f", mealkit.price))
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.top, 5)
            }
        }
    }
}
