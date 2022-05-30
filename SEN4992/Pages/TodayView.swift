//
//  TodayView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct TodayView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2State: Co2State
    @State private var name = ""
    @State private var timeMessage = ""
    private var userApi = UserApi()
    @State private var date = Date()
    @State private var hour = Calendar.current.component(.hour, from: Date())
    @Environment(\.scenePhase) var scenePhase
    
    
    
    
    
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(spacing:0){
                
                HStack{
                    VStack(alignment: .leading){
                        Text(date, style: Text.DateStyle.date)
                            .foregroundColor(.secondary)
                            .font(.callout)
                        
                        Text("\(timeMessage)\(name)")
                            .foregroundColor(Color(uiColor: .label))
                            .font(.headline)
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                    
                    NavigationLink {
                        UserSettings()
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(Color(uiColor: .label))
                            .padding(10)
                            .background()
                            .cornerRadius(8)
                    }
                    
                    
                }//: hstack
                .padding(.horizontal)
                
                DailyGraphUI()
                    .padding()
                
                HStack {
                    TodayPercentage()
                        .frame(maxHeight:.infinity)
                    //                TodayPercentage()
                    CategoryView()
                        .frame(maxHeight:.infinity)
                    
                    
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.bottom)
                
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
            .navigationBarHidden(true)
            .onAppear {
                
                timeMessage = hourCheck()
                name = userNameDisplay()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                    self.hour = Calendar.current.component(.hour, from: Date())
                    withAnimation {
                        timeMessage = hourCheck()
                    }
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
            
        }
        .accentColor(.white)
    }
        
    private func userNameDisplay() -> String {
        let dbName = userApi.currentUserName
        return dbName != "" ? ", \(dbName)" : ""
    }
    
    private func hourCheck() -> String {
        switch hour {
        case 7..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(Co2State(currentCo2State: 30))
            .preferredColorScheme(.light)
    }
}
