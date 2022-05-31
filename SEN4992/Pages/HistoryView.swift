//
//  HistoryView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct HistoryView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2State : Co2State
    
    @State var selectedItem: Entry?
    @State var co2entered: String = ""
    @State var selectedRecurrence: String = "1"
    @State var selectedDate: Date = Date()
    
    //MARK: - Body
    var body: some View {
        VStack {
            Text("Emission History")
                .font(.largeTitle)
                .padding(.top)
                .foregroundColor(.white)
            
            HistoryListView(items: co2State.addedItems.reversed(), selectedItem: $selectedItem, co2entered: $co2entered, selectedRecurrence: $selectedRecurrence, selectedDate: $selectedDate)
                .environmentObject(co2State)
        }
        .background(Color("customDynamicDarkBlue"))
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
