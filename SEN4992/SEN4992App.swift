//
//  SEN4992App.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 23.03.2022.
//

import SwiftUI

@main
struct SEN4992App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomePage()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
