//
//  LiveFitFood_SwiftUIApp.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-03-17.
//

import SwiftUI

@main
struct LiveFitFood_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
            
            LoginScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(LoginViewModel())
        }
    }
}
