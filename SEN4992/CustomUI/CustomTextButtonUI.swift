//
//  CustomTextButtonUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 5.04.2022.
//

import SwiftUI

struct CustomTextButtonUI: View {
    
    @State var text: String? = ""
    @State var bttnText: String? = ""
    @State var function: () -> Void? = {return}
    
    
    var body: some View {
        
        HStack(spacing:5) {
            Text(text ?? "")
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Button {
                function()
            } label: {
                Text(bttnText ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .font(.footnote)
        
    }
}

struct CustomTextButtonUI_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextButtonUI(text: "Didn't receive the link", bttnText: "Resend")
    }
}
