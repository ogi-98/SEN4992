//
//  MainView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 18.04.2022.
//

import SwiftUI

struct MainView: View {
    let userApi = UserApi()
    
    var body: some View {
                VStack {
                    Text("Hello, World!\nuser id:  \(userApi.currentUserId)\nname: \(userApi.currentUserName)")
                    CustomButtonUI(function: {
                        userApi.logOut {
                            userApi.userLoginPageCheck()
                        } onError: { err in
                            print(err)
                        }
        
                    }, title: "LogOut")
                }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
