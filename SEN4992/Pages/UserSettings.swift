//
//  UserSettings.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 25.05.2022.
//

import SwiftUI

struct UserSettings: View {
    //MARK: - PROPERTIES
    let userApi = UserApi()
    @State private var name: String = ""
    @ScaledMetric var scale: CGFloat = 1.0
    
    enum Pages {
        case main, settings
    }
    @State private var selectedPage: Pages = .main
    @State private var showingDialog = false
    
    //MARK: - Body
    var body: some View {
        VStack(alignment:.center) {
            VStack {
                Text(userApi.currentUserName == "" ? "Settings":userApi.currentUserName)
                    .font(.largeTitle)
                    .frame(maxWidth:.infinity,alignment: .leading)
                HStack(spacing: 0) {
                    Text("Member since ")
                    Text(userApi.currentUserCreatedDate,style: .date)
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
                            
                            fetchView()
                            
                        }//: Carview background
                        .frame(maxWidth:.infinity,alignment: .center)
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .cornerRadius(30, corners: [.topLeft,.topRight])
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    
                    Image("PersonalSettings")
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
    
    @ViewBuilder private func fetchView() -> some View {
        switch selectedPage {
        case .main:
            settingsMainUI
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
        case .settings:
            userSettingsUI
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        default:
            settingsMainUI
        }
    }
    
    var userSettingsUI: some View {
        VStack{
            Text("Account Settings")
                .font(.title3)
                .fontWeight(.medium)
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding()
                .padding(.top,40)
            
            CustomLabelUI(title: "Name")
            
            CustomLabelUI(title: "Email", selectedText: .email)
            
            NavigationLink {
                PasswordChange()
            } label: {
                HStack{
                    Text("Change Password")
                    Spacer()
                    Image(systemName: "chevron.forward")
                }
            }
            .foregroundColor(Color(uiColor: .label))
            .padding(.vertical,10)
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            
            Button {
                withAnimation {
                    selectedPage = .main
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.backward.2")
                    Text("Return to Settings")
                }
                .frame(maxWidth: .infinity)
                .padding(7)
            }
            .tint(.green)
            .buttonStyle(.bordered)
            .padding(.top)
            .padding(.horizontal)
            
            Spacer()
        }
    }
    var settingsMainUI: some View {
        VStack{
            Button {
                // switch to user settings
                withAnimation {
                    selectedPage = .settings
                }
            } label: {
                HStack{
                    Button {
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(.bordered)
                    .tint(.yellow)
                    
                    Text("Account Settings")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .frame(maxWidth:.infinity,alignment: .leading)
                    Image(systemName: "chevron.forward")
                    
                }
            }
            .tint(Color(uiColor: .secondaryLabel))
            .padding(.top,75)
            .padding(.horizontal)
            
            Button {                
                showingDialog = true
                
            } label: {
                HStack{
                    Button {
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title2)
                            .padding(2)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    Text("Log Out")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .frame(maxWidth:.infinity,alignment: .leading)
                    
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .confirmationDialog("Are you sure to LogOut", isPresented: $showingDialog,titleVisibility: .visible) {
                
                Button("LogOut",role: .destructive) {
                    userApi.logOut {
                        showingDialog = false
                            userApi.userLoginPageCheck()
                        
                    } onError: { errorMessage in
                        print(errorMessage)
                    }
                }
                
            }
            
            Spacer()
        }
    }
    
    
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}




struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
