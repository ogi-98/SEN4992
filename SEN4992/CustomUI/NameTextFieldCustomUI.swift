//
//  NameTextFieldCustomUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 18.04.2022.
//

import SwiftUI

struct NameTextFieldCustomUI: View {
    @State var name: Binding<String>
    @State var color: Color = Color.blue
    var body: some View {
        VStack(spacing: 0) {
            TextField("Name *Optional", text: name)
                .padding()
                .autocapitalization(.words)
                .disableAutocorrection(false)
                .textContentType(.name)
                .cornerRadius(12)
            Rectangle()
                .fill(color)
                .frame(height: 2)
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
}

struct NameTextFieldCustomUI_Previews: PreviewProvider {
    static var previews: some View {
        NameTextFieldCustomUI(name: .constant(""))
    }
}
