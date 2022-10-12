//
//  EmailUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 4.04.2022.
//

import SwiftUI

struct EmailTextFieldCustomUI: View {
    @State var email: Binding<String>
    @State var color: Color = Color.blue
    var body: some View {
        VStack(spacing: 0) {
            TextField("Email", text: email)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(false)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .cornerRadius(12)
            
            Rectangle()
                .fill(color)
                .frame(height: 2)
                .edgesIgnoringSafeArea(.horizontal)
            
        }
    }
}

struct EmailUI_Previews: PreviewProvider {
    
    static var previews: some View {
        EmailTextFieldCustomUI(email: .constant(""))
    }
}

