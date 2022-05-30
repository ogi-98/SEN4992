//
//  CustomLabelUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 30.05.2022.
//

import SwiftUI

struct CustomLabelUI: View {
    private let userApi = UserApi()
    @State var title: String = ""
    enum Labels{
        case name,email
    }
    @State var selectedText: Labels = .name
    var body: some View {
        VStack{
            HStack{
                Text(title)
                Spacer()
                buildSelectedText()
            }
            .padding(.vertical,15)
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder private func buildSelectedText() -> some View {
        switch selectedText {
        case .name:
            Text(userApi.currentUserName == "" ? title:userApi.currentUserName)
                .fontWeight(.light)
        case .email:
            Text(userApi.currentUserName == "" ? title:userApi.currentUserMail)
                .fontWeight(.light)
        default:
            Text(userApi.currentUserName == "" ? title:userApi.currentUserName)
                .fontWeight(.light)
        }
    }
}

struct CustomLabelUI_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabelUI()
    }
}
