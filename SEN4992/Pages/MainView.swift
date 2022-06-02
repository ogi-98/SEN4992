//
//  MainView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 18.04.2022.
//

import SwiftUI

struct MainView: View {
    //MARK: - PROPERTIES
    
    private var userCo2Model: Co2Model = Co2Model(currentCo2State: 20.0)
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
    }
    //MARK: - BODY
    var body: some View {
        TabView {
                TodayView()
                .environmentObject(userCo2Model)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Today")
                }
                AddView()
                .environmentObject(userCo2Model)
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add")
                }
                HistoryView()
                .environmentObject(userCo2Model)
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
