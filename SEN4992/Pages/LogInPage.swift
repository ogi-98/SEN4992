//
//  LogInPage.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 23.03.2022.
//

import SwiftUI

struct LogInPage: View {
    
    //MARK: - properties
    enum Fields {
        case email
        case password
    }
    
    
    @State private var email = ""
    @State private var pass = ""
    @State private var visible = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var alertShow = false
    
    @State private var forgotShow = false
    
    @FocusState private var focusedField: Fields?
    
    
    
    
    //MARK: - body
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Image("Login")
                .resizable()
                .scaledToFit()
                .padding(.horizontal,120)
            Text("Hello Again!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome back, you've \nbeen missed!")
                .font(.title3)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .frame(minHeight: 50)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            
            VStack(alignment: .center, spacing: 10.0) {
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .padding()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(12)
                
                
                HStack(alignment: .center, spacing: 2.0){
                    
                        
                        if self.visible{
                            TextField("Password", text: $pass)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                            .padding()
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .textContentType(.password)
                            .keyboardType(.default)
                        }
                        else{
                            SecureField("Password", text: $pass)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                            .padding()
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .textContentType(.password)
                            .keyboardType(.default)
                        }
                    
                    Button(action: {
                        self.visible.toggle()
                    }) {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        
                    }//: visible buton
                    .padding(8)
                    
                }//:  password hstack
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                Button {
                    //TODO: Password forgot navigate
                    forgotBttnTouch()
                } label: {
                    Text("Recovery Password")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }//: forgot buton
                .sheet(isPresented: $forgotShow, content: {
                    ForgotPasswordPage()
                })
                .padding(.top,4)
            }//: vstak textfields
            .padding(30)
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                case .password:
                    LoginBttnTouch()
                default:
                    break
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard ) {
                    if !forgotShow {
                        HStack {
                            Spacer()
                            Button {
                                focusedField = nil
                            } label: {
                                Text("Done")
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
            }//: toolbar
            
            Button {
                LoginBttnTouch()
            } label: {
                Text("Log In")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity,alignment: .center)
                    .padding()
                    .background(.green)
                    .cornerRadius(12)
                    .padding(.horizontal,30)
                
            }//: login buton
            .alert(isPresented: $alertShow) {
                
                Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .cancel())
                
            }
            
            Spacer()
            Spacer()
                        
            HStack(spacing:5) {
                Text("Not a member?")
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                Button {
                    //TODO: create user navigate
                } label: {
                    Text("Register now")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

            }//: regiter buton
            .font(.footnote)
            .padding(.bottom)
                        
        }//: vstack
        .background(
            Color(uiColor: .systemGroupedBackground)
        )
        .onTapGesture {
            if focusedField != nil {
                focusedField = nil
            }
        }
        
    }
    
    
    
    //MARK: - Funcs
    private func forgotBttnTouch(){
        focusedField = nil
        forgotShow.toggle()
    }
    private func showAlert(title: String,message:String){
        alertTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        alertMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        alertShow = true
    }
    
    private func LoginBttnTouch(){
        focusedField = nil
        
        let sendingEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let sendingPassword = pass.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sendingEmail != "" && sendingPassword != "" {
            if !isValidEmail(email){
                showAlert(title: "Invalid!", message: "Invalid Email")
                print("gecersiz mail")
                return
            }
            
            showAlert(title: "Success!", message: "suanlik isteklerimizi karsiliyor ilerde password lenght check koyariz")
            
        }else{
            showAlert(title: "Empty Fields!", message: "Make sure all fields are not empty")
            print("make sure all fields are not empty")
        }
        
    }
    
    
    
    
    
    
    
    
}//: end of class



struct LogInPage_Previews: PreviewProvider {
    static var previews: some View {
        LogInPage()
            .preferredColorScheme(.light)
    }
}
