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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MealkitDetailsView_Previews: PreviewProvider {
    static var previews: some View {        
        MealkitDetailsView(mealkit: Mealkit())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
