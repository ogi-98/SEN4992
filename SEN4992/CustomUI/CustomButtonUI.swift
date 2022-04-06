//
//  CustomButtonUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 4.04.2022.
//

import SwiftUI

struct CustomButtonUI: View {
    
    @State var function: () -> Void? = {return}
    @State var title: String? = "Log In"
    
    var body: some View {
        Button {
            function()
        } label: {
            Text(title ?? "")
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity,alignment: .center)
                .padding()
                .background(.green)
                .cornerRadius(12)
            
        }//: login buton
    }
}

struct CustomButtonUI_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonUI()
    }
}
