//
//  SEN4992App.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 23.03.2022.
//

import SwiftUI
import Firebase

@main
struct SEN4992App: App {
    let persistenceController = PersistenceController.shared
    private var userApi = UserApi()
    @AppStorage("isLogin") var isUserLogin: Bool = true
    
    init() {
        FirebaseApp.configure()
        userApi.userLoginPageCheck()
//        isUserLogin = userApi.userIsLogdedIn()
        print("user is login fonksiyon sonrası: \(isUserLogin) ")
//        isUserLogin = userApi.userIsLogdedIn()
    }

    var body: some Scene {
        WindowGroup {
            if isUserLogin {
                MainView()
            } else {
                WelcomePage()
            }
//            ForgotPasswordPage()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
