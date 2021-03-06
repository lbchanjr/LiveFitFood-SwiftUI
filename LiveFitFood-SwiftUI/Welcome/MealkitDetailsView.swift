//
//  MealkitDetailsView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-31.
//

import SwiftUI


struct MealkitDetailsView: View {
    @Binding var isActive: Bool
    @EnvironmentObject var mealkit: Mealkit
    @EnvironmentObject var loggedUser: LoggedInUser
    
    var body: some View {
        VStack {
            //List(meals, id: \.self) { meal in
            List {
                ForEach(mealkit.meals?.allObjects as! [Meal]) { meal in
                    //Text((meal as Meal).name ?? "")
                    MealDetailsView(meal: meal)
                }
            }.padding(.bottom, 10)
            
            NavigationLink(destination: CheckoutView(isActive: $isActive, checkoutViewModel: CheckoutViewModel(email: loggedUser.email, mealkit: mealkit))
                //            .environmentObject(mealkit)
            ) {
                Text("Checkout")
                    .frame(width: UIScreen.main.bounds.width * 0.65)
                    .padding(.vertical)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title3)
            }
            .padding(.bottom, 5)
        }
        .navigationBarTitle(mealkit.name ?? "")
    }
}

struct MealkitDetailsView_Previews: PreviewProvider {
    static var previews: some View {        
        MealkitDetailsView(isActive: .constant(true)/*mealkit: MockData().getMealkit()*/)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(MockData().getMealkit())
    }
}

struct MealDetailsView: View {
    var meal: Meal
    var body: some View {
        HStack {
            Image((meal as Meal).photo ?? "noimage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            VStack(alignment: .leading) {
                Spacer()
                Text((meal as Meal).name ?? "")
                    .bold()
                    .font(.title3)
                Spacer()
                Text("\(String((meal as Meal).calories))kCal")
                    .font(.title3)
                Spacer()
            }
        }
    }
}
