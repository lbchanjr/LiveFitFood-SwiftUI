//
//  HeaderView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-21.
//

import SwiftUI

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
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
