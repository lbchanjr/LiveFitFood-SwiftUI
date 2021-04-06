//
//  OrderSummaryView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-04.
//

import SwiftUI

struct OrderSummaryView: View {
    @Binding var isActive: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text("Hello World!")
            Button("Back", action: {
                
                //presentationMode.wrappedValue.dismiss()
                //print("isActive = \(isActive)")
                isActive = false
                //print("isActive = \(isActive)")
                
            })
        }
            .navigationBarBackButtonHidden(true)
    }
}

struct OrderSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSummaryView(isActive: .constant(true))
    }
}
