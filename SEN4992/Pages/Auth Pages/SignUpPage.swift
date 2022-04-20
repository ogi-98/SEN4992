//
//  SignUpPage.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 5.04.2022.
//

import SwiftUI

struct SignUpPage: View {
    
    @Environment(\.presentationMode) private var presentationMode
    //MARK: - Properties
    enum Fields {
        case name
        case email
        case password
        case rePassword
    }
    @FocusState private var focusedField: Fields?
    
    @State private var name = ""
    @State private var email = ""
    @State private var pass = ""
    @State private var rePass = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertShow = false
    
//    private var loginPage = LogInPage()
    private let userApi = UserApi()
    
    @State private var isLoading = false
    
    
    
    //MARK: - Body
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                Image("SignUp")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal,90)
                Text("Create Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Looks like you dont't have an account.\n Let's cretae a new account!")
                    .font(.body)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .frame(minHeight:45)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                
                
                VStack(alignment: .center, spacing: 10.0) {
                    
                    NameTextFieldCustomUI(name: $name)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                    EmailTextFieldCustomUI(email: $email)
                        .focused($focusedField,equals: .email)
                        .submitLabel(.next)
                    
                    PasswordTextfieldCustomUI(pass: $pass,textContentType: .newPassword)
                        .submitLabel(.next)
                        .focused($focusedField,equals: .password)
                    
                    PasswordTextfieldCustomUI(pass: $rePass,plcholder: "Confirm Password",textContentType: .newPassword)
                        .submitLabel(.go)
                        .focused($focusedField,equals: .rePassword)
                    
                    
                }//: vstak textfields
                .padding(.vertical,30)
                .onSubmit {
                    switch focusedField {
                    case .name:
                        focusedField = .email
                    case .email:
                        focusedField = .password
                    case .password:
                        focusedField = .rePassword
                    case .rePassword:
                        SignUpBttnTouch()
                    default:
                        break
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack{
                            Spacer()
                            Button {
                                focusedField = nil
                            } label: {
                                Text("Done")
                            }

                        }
                    }
                }//: toolbar
                
                
                CustomButtonUI(function: SignUpBttnTouch, title: "Sign Up")
                
                
                Spacer()
                
                NavigateTextButtonUI(text: "Joined us before?", bttnText: "Login", destination: AnyView(LogInPage().navigationBarHidden(true)))

                
                
            }//: VStack
            .padding(.horizontal,30)
            .background(
                Color(uiColor: .systemGroupedBackground)
            )
            .onTapGesture {
                if focusedField != nil {
                    focusedField = nil
                }
            }
            .alert(alertTitle, isPresented: $alertShow) {
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("\(alertMessage)")
            }
            
            
            
            if isLoading {
                CustomSpinner(repeats: isLoading)
            }
            
        }

        
    }
    //MARK: - Funcs
    
    private func SignUpBttnTouch(){
        focusedField = nil
        
        let sendingName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let sendingEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let sendingPassword = pass.trimmingCharacters(in: .whitespacesAndNewlines)
        let rePassword = rePass.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sendingEmail != "" && sendingPassword != "" && rePassword != ""{
            if !isValidEmail(sendingEmail){
                showAlert(title: "Invalid!", message: "Invalid Email")
                print("gecersiz mail")
                return
            }
            
            if sendingPassword != rePassword {
                showAlert(title: "Passwords are not match!", message: "Please check passwords")
                return
            }
            
            isLoading = true
            userApi.createUser(name: sendingName, mail: sendingEmail, password: sendingPassword) {
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
    
    
    private func showAlert(title: String,message:String){
        alertTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        alertMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        alertShow = true
    }
    
    
    
    
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
