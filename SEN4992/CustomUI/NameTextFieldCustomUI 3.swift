//
//  NameTextFieldCustomUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 18.04.2022.
//

import SwiftUI

struct NameTextFieldCustomUI: View {
    @State var name: Binding<String>
    var body: some View {
        TextField("Name *Optional", text: name)
            .padding()
            .autocapitalization(.words)
            .disableAutocorrection(false)
            .textContentType(.name)
//            .background(Color(uiColor: .tertiarySystemBackground))
            .background(Color("customTextFieldGreen"))
            .cornerRadius(12)
    }
}

struct NameTextFieldCustomUI_Previews: PreviewProvider {
    static var previews: some View {
        NameTextFieldCustomUI(name: .constant(""))
    }
}
