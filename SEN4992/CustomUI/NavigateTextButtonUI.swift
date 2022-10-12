//
//  NavigateTextButtonUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 5.04.2022.
//

import SwiftUI

struct NavigateTextButtonUI: View {
    
    @State var text: String? = ""
    @State var bttnText: String? = ""
    @State var destination: AnyView?
    @State var color: Color = Color("AlternateButtonColor")
    var body: some View {
        
        HStack(spacing:5) {
            Text(text ?? "")
                .foregroundColor(Color(uiColor: .secondaryLabel))
            if destination != nil {
                NavigationLink {
                    destination
                } label: {
                    Text(bttnText ?? "")
                        .fontWeight(.bold)
                        .foregroundColor(color)
                }
            }else {
                Text(bttnText ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
        }
        .font(.footnote)
        
    }
}

struct NavigateTextButtonUI_Previews: PreviewProvider {
    static var previews: some View {
        NavigateTextButtonUI(text: "Didn't receive the link", bttnText: "Resend")
    }
}
