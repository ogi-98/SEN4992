//
//  EmailUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 4.04.2022.
//

import SwiftUI

struct EmailUI: View {
    @State var email: Binding<String>
    var body: some View {
        TextField("Email", text: email)
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(false)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(13)
    }
}

struct EmailUI_Previews: PreviewProvider {
    
    static var previews: some View {
        EmailUI(email: .constant(""))
    }
}

