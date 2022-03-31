//
//  WelcomePage.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 28.03.2022.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center, spacing: 10) {
                Image("welcomePhoto")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                NavigationLink(
                    destination: LogInPage(),
                    label: {
                        Text("Get Started")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(uiColor: .white))
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15)
                    })
                
                NavigationLink(
                    destination: LogInPage().navigationBarHidden(true),
                    label: {
                        Text("Log In")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.green)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(15.0)
                            .padding(.vertical)
                    })
                

            }//: VStack
            .padding()
            .navigationBarHidden(true)
        }//: NavigationView
    }
}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
            .preferredColorScheme(.light)
    }
}
