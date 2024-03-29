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
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var alertShow = false
    
    @State private var forgotShow = false
    
    @FocusState private var focusedField: Fields?
    private let userApi = UserApi()
    
    @State private var isLoading = false
    
    
    
    
    //MARK: - body
    var body: some View {
        ZStack{
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
                    
                    
                    EmailTextFieldCustomUI(email: $email)
                        .focused($focusedField,equals: .email)
                        .submitLabel(.next)
                    
                    PasswordTextfieldCustomUI(pass: $pass)
                        .submitLabel(.go)
                        .focused($focusedField,equals: .password)
                    
                    Button {
                        forgotBttnTouch()
                    } label: {
                        Text("Forgot your password?")
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
                
                CustomButtonUI(function: LoginBttnTouch, title: "Log In")
                    .padding(.horizontal,30)
                    .alert(isPresented: $alertShow) {
                        
                        Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .cancel())
                        
                    }
                
                Spacer()
                Spacer()
                            
                NavigateTextButtonUI(text: "Not a member?", bttnText: "Register now",destination: AnyView(SignUpPage().navigationBarHidden(true)))
                .padding(.bottom)
                            
            }//: vstack
            .background(
                Color(uiColor: .systemBackground)
//                Color(uiColor: .systemGroupedBackground)
            )
            .onTapGesture {
                if focusedField != nil {
                    focusedField = nil
                }
            }
            
        
            
            if isLoading {
                CustomSpinner(repeats: isLoading)
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
            if !isValidEmail(sendingEmail){
                showAlert(title: "Invalid email!", message: "Please check your email")
                print("gecersiz mail")
                return
            }
            isLoading = true
            userApi.userLogin(mail: sendingEmail, password: sendingPassword) {
                isLoading = false
                userApi.userLoginPageCheck()
            } onError: { errorMessage in
                isLoading = false
                showAlert(title: "Error!", message: errorMessage)
            }
            
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
