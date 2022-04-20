//
//  MainView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 18.04.2022.
//

import SwiftUI

struct MainView: View {
    //MARK: - PROPERTIES
    
    
    
    init() {
    }
    //MARK: - BODY
    var body: some View {
        TabView {
                TodayView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Today")
                }
                AddView()
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
