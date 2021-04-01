//
//  MealkitDetailsView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-31.
//

import SwiftUI


struct MealkitDetailsView: View {
    
    var mealkit: Mealkit
    var body: some View {
        VStack {
            //List(meals, id: \.self) { meal in
            List {
                ForEach(mealkit.meals?.allObjects as! [Meal]) { meal in
                    //Text((meal as Meal).name ?? "")
                    HStack {
                        Image((meal as Meal).photo ?? "noimage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                            .clipped()
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
            }.padding(.bottom, 10)
            Button("Checkout", action: {})
                .frame(width: UIScreen.main.bounds.width * 0.7)
                .padding(.vertical)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .font(.title3)
        }
        .navigationBarTitle(mealkit.name ?? "")
    }
}

struct MealkitDetailsView_Previews: PreviewProvider {
    static var previews: some View {        
        MealkitDetailsView(mealkit: Mealkit())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
