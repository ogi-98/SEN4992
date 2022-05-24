//
//  HistoryView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct HistoryView: View {
    //MARK: - PROPERTIES
    let userApi = UserApi()
    
    
    
    
    
    
    
    //MARK: - Body
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
