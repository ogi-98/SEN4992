//
//  PasswordChange.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 31.05.2022.
//

import SwiftUI

struct PasswordChange: View {
    //MARK: - PROPERTIES
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var newRePassword: String = ""
    
    
    
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment:.center) {
            VStack {
                Text("Update Password")
                    .font(.largeTitle)
                    .frame(maxWidth:.infinity,alignment: .leading)
                HStack(spacing: 0) {
                    Text("Fill in the form to update your password")
                }
                .font(.footnote)
                .frame(maxWidth:.infinity,alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            GeometryReader { geo in
                
                ZStack(alignment:.top) {
                    VStack{
                        Spacer()
                            .frame(maxHeight:geo.size.height * 0.24)
                        VStack {
                            VStack {
                                PasswordTextfieldCustomUI(pass: $oldPassword, plcholder: "Old Password", textContentType: .password)
                                PasswordTextfieldCustomUI(pass: $newPassword, plcholder: "New Password", textContentType: .newPassword)
                                PasswordTextfieldCustomUI(pass: $newRePassword, plcholder: "Confirm New Password", textContentType: .password)
                            }
                            .accentColor(.blue)
                            .padding(.horizontal)
                            .padding(.top,60)
                            
                            Button {
                                
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                    Text("Update Password")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(7)
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .padding(.top)
                            .padding(.horizontal)
                            Spacer()
                            
                        }//: Carview background
                        .frame(maxWidth:.infinity,alignment: .center)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(30, corners: [.topLeft,.topRight])
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    
                    Image("PasswordUpdate")
                        .resizable()
                        .frame(width: geo.size.height * 0.25, height: geo.size.height * 0.25, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .clipShape(Circle())
                        .shadow(color: Color(uiColor: .lightGray).opacity(0.3), radius: 2, x: 0, y: 3)
                    
                }
                
                
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .top)
        .background(Color("MainColor"))
    }
    
    //MARK: - FUNCS
}

struct PasswordChange_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChange()
    }
}
