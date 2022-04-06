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
//    AnyView = {Text("Fail")}()
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
                        .foregroundColor(.green)
                }
            }else {
                Text(bttnText ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
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
