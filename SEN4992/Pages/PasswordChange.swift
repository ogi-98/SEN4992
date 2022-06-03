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
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertShow = false
    
    enum Fields {
        case oldPassword
        case password
        case rePassword
    }
    @FocusState private var focusedField: Fields?
    
    private var userApi = UserApi()
    
    
    
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
                                    .submitLabel(.next)
                                    .focused($focusedField, equals: .oldPassword)
                                PasswordTextfieldCustomUI(pass: $newPassword, plcholder: "New Password", textContentType: .newPassword)
                                    .submitLabel(.next)
                                    .focused($focusedField, equals: .password)
                                PasswordTextfieldCustomUI(pass: $newRePassword, plcholder: "Confirm New Password", textContentType: .password)
                                    .submitLabel(.go)
                                    .focused($focusedField, equals: .rePassword)
                            }
                            .accentColor(.blue)
                            .padding(.horizontal)
                            .padding(.top,60)
                            .onSubmit {
                                switch focusedField {
                                case .oldPassword:
                                    focusedField = .password
                                case .password:
                                    focusedField = .rePassword
                                case .rePassword:
                                    passwordUpdate()
                                default:
                                    break
                                }
                            }//: on submit
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack{
                                        Spacer()
                                        Button {
                                            focusedField = nil
                                        } label: {
                                            Text("Done")
                                        }
                                        .tint(Color("AlternateButtonColor"))

                                    }
                                }
                            }//: toolbar
                            
                            Button {
                                passwordUpdate()
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
                .onTapGesture {
                    focusedField = nil
                }
                
                
            }
        }//: vstack
        .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .top)
        .background(Color("MainColor"))
        .alert(alertTitle, isPresented: $alertShow) {
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("\(alertMessage)")
        }
    }
    
    //MARK: - FUNCS
    private func passwordUpdate() {
        let passwordOld = oldPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordNew = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordReNew = newRePassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let userMail = userApi.currentUserMail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if passwordOld.isEmpty || passwordNew.isEmpty || passwordReNew.isEmpty {
            // bosluklari doldur
            showAlert(title: "Empty Fields!", message: "Make sure all fields are not empty")
        }else if passwordNew != passwordReNew {
            // yeni passler eslesmiyor
            print("Passler eslesmiyor")
            showAlert(title: "Passwords Does not Match", message: "New Passwords does not match")
        }else {
            // basarili
            userApi.userReAuth(mail: userMail, password: passwordOld) {
                // succes reauth
                
                if passwordNew == passwordOld {
                    // eski pass yeni pass olamaz
                    print("eski pass yeni pass olamaz")
                    showAlert(title: "Same Password", message: "Your old password cannot be the same as your new password.")
                }else {
                    userApi.userUpdatePassword(password: passwordNew) {
                        // basarili update
                        print("Basarili update")
                        showAlert(title: "Successful Update", message: "Your password has been successfully updated. Now your account is more secure 😄")
                    } onError: { errorMessage in
                        // basarisiz update
                        print("Basarisiz update: \(errorMessage)")
                        showAlert(title: "Error!", message: errorMessage)
                    }
                }

                
            } onError: { errorMessage in
                // error reAuth
                print("Error ReAuth: \(errorMessage)")
                showAlert(title: "Error!", message: errorMessage)
            }

        }
        
    }
    
    
    private func showAlert(title: String,message:String){
        alertTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        alertMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        alertShow = true
    }
    
    
}

struct PasswordChange_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChange()
    }
}
