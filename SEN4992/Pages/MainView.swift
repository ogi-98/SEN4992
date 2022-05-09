//
//  MainView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 18.04.2022.
//

import SwiftUI

struct MainView: View {
    //MARK: - PROPERTIES
    
    private var userCo2State: Co2State = Co2State(currentCo2State: 20.0)
    
    init() {
    }
    //MARK: - BODY
    var body: some View {
        TabView {
                TodayView()
                .environmentObject(userCo2State)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Today")
                }
                AddView()
                .environmentObject(userCo2State)
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add")
                }
                HistoryView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("History")
                }
            }//: tabview
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.light)
    }
}
