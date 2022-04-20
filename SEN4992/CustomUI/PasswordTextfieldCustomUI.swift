//
//  PasswordTextfieldCustomUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 5.04.2022.
//

import SwiftUI

struct PasswordTextfieldCustomUI: View {
    
    var placeholder: String?
    @Binding var pass: String
    @State var textContentType: UITextContentType
    init(pass: Binding<String> = .constant(""), plcholder: String = "Password", textContentType: UITextContentType = .password) {
        _pass = pass
        self.placeholder = plcholder
        self.textContentType = textContentType
    }
    @State private var secure = false
    
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 2.0){


                if self.secure{
                    TextField(placeholder ?? "Password", text: $pass)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .padding()
                    .textContentType(textContentType)
                    .keyboardType(.default)
                }
                else{
                    SecureField(placeholder ?? "Password", text: $pass)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .padding()
                    .textContentType(textContentType)
                    .keyboardType(.default)
                }

            Button(action: {
                self.secure.toggle()
            }) {
                Image(systemName: self.secure ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(Color(uiColor: .secondaryLabel))

            }//: visible buton
            .padding(8)

        }//:  password hstack
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(12)
        
    }
}

struct PasswordTextfieldCustomUI_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextfieldCustomUI()
    }
}
