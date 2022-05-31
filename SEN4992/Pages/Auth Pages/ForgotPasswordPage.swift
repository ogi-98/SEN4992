//
//  ForgotPasswordPage.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 3.04.2022.
//

import SwiftUI

struct ForgotPasswordPage: View {
    
    //MARK: - Proporties
    
    @Environment(\.presentationMode) private var presentationMode
    
    enum Field {
        case email
    }
    @FocusState private var focusedFieldForgot: Field?
    
    @State private var email = ""
    @State private var didSend = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var alertShow = false
    private let userApi = UserApi()
    
    
    //MARK: - Body
    var body: some View {
        fetchView()
            .background(Color(uiColor: .systemBackground))
            .onTapGesture {
                if focusedFieldForgot != nil {
                    focusedFieldForgot = nil
                }
            }
    }
    
    private func sendTouch(){
        let sendEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(sendEmail) {
            sendSuccessful(sendEmail: sendEmail)
        }else{
            //alert
            showAlert(title: "Invalid Email!", message: "Check the validity of the Email")
        }
    }
    private func showAlert(title: String,message:String){
        alertTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        alertMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        alertShow = true
    }
    
    private func sendSuccessful(sendEmail:String){
        userApi.sendPasswordReset(mail: sendEmail) {
            withAnimation {
                didSend = true
            }
        } onError: { errorMessage in
            print(errorMessage)
            withAnimation {
                didSend = true
            }
        }
        
        
    }
    private func goToResendView(){
        withAnimation {
            didSend = false
        }
    }
    
    @ViewBuilder private func fetchView() -> some View {
        if !didSend {
            emailView
        }else {
            sendedView
        }
    }
    
    var emailView: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Forgot your password?")
                .font(.title3)
                .fontWeight(.bold)
            Text("Enter your registered email below\n to receive password reset instruction")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .frame(minHeight:35)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            
            ZStack(alignment: .bottom) {
                Image("ForgotPassword")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth:200, minHeight:200)
                
                HStack {
                    Spacer()
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .padding()
                        .background(Color("customStaticLightBlue"))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .scaledToFit()
                    
                }
                
            }
            .padding(.horizontal,70)
            
            VStack(alignment:.center,spacing:15){
                EmailTextFieldCustomUI(email: $email)
                    .submitLabel(.send)
                    .focused($focusedFieldForgot,equals: .email)
                    .submitLabel(.send)
                    .onSubmit {
                        switch focusedFieldForgot {
                        case .email:
                            sendTouch()
                        default:
                            break
                        }
                    }
                
                CustomTextButtonUI(text: "Remember password?", bttnText: "Login") {
                    presentationMode.wrappedValue.dismiss()
                }//: remember password buton
                
            }
            .padding(.horizontal,30)
            
            
            CustomButtonUI(function: sendTouch, title: "Send")
                .padding(.horizontal,30)
                .alert(isPresented: $alertShow){
                    Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .cancel())
                }
            
            Spacer()
            Spacer()
        }//: vstack background
    }
    var sendedView: some View {
        VStack(spacing: 25) {
            Spacer()
            Text("Email has been sent!")
                .font(.title3)
                .fontWeight(.bold)
            Text("Please check your inbox and click\n in the received link to reset password")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(Color(uiColor: .secondaryLabel))
                .frame(minHeight:35)
            
            ZStack(alignment: .bottomTrailing) {
                Image("ForgotPassword")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth:200)
                
                HStack {
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.title)
                        .padding()
                        .background(Color("customStaticLightBlue"))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                    
                }
                
            }
            .padding(.horizontal,70)
            
            CustomButtonUI(function: {
                presentationMode.wrappedValue.dismiss()
            }, title: "Login")
            .padding(.horizontal, 30)
            //: login button
            
            CustomTextButtonUI(text: "Didn't receive the link?", bttnText: "Resend", function: goToResendView)
            //: resend button
            
            Spacer()
        }//: vstack background
    }
    
    
    
    
}//: forgotpaswordclass


struct ForgotPasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordPage()
    }
}
