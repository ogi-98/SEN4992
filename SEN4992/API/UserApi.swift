//
//  UserApi.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 17.04.2022.
//

import SwiftUI
import Firebase


class UserApi: ObservableObject {
    
    @AppStorage("isLogin") var isUserLogin: Bool = true
    
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }//: currentUserId Var
    
    var currentUserName: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.displayName ?? "isim yok" : ""
    }
    
    func createUser(name: String = "", mail: String, password: String, onSuccess: @escaping() -> Void,onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, err in
            if err == nil {
                print("succesful creating user")
                
                if name != ""{
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges(completion: { error in
                        if error == nil {
                            onSuccess()
                        }else {
                            onError(error?.localizedDescription ?? SIGNUP_UNSUCCESS)
                        }
                    })
                }else{
                    onSuccess()
                }
                
                
            }else {
                print("un-seccesful creting user")
                print(err?.localizedDescription as Any)
                onError(err?.localizedDescription ?? SIGNUP_UNSUCCESS)
            }
        }
    }//: createUserFunc
    
    func userLogin(mail: String, password: String, onSuccess: @escaping() -> Void,onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, err in
            if err == nil {
                onSuccess()
            }else {
                print("kullanici giris basarisiz")
                print(err as Any)
                onError(err?.localizedDescription ?? LOGIN_UNSUCCESS)
            }
        }
    }//: userLoginFunc
    
    
    func userIsLogdedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            return true
            // ...
        } else {
            // No user is signed in.
            return false
            // ...
        }
    }//: userIsLogdedInFunc
    
    func userLoginPageCheck() {
        isUserLogin = userIsLogdedIn()
        
    }
    
    func logOut(onSuccess: @escaping() -> Void,onError: @escaping(_ errorMessage: String) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            onError(signOutError.localizedDescription)
            return
        }
        
        onSuccess()
        
    }
    
    func sendPasswordReset(mail: String,onSuccess: @escaping() -> Void,onError: @escaping(_ errorMessage: String) -> Void) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.sendPasswordReset(withEmail: mail) { error in
            if error == nil {
                onSuccess()
            }else{
                let errorMessage = "Password Reset Error: " + (error?.localizedDescription ?? "")
                onError(errorMessage)
            }
        }
        
    }
    
}
