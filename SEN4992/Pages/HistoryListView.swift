//
//  HistoryListView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 26.05.2022.
//

import SwiftUI

struct HistoryListView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2State : Co2State
    
    var items: [Entry]
    @Binding var selectedItem: Entry?
    @Binding var co2entered: String
    @Binding var selectedRecurrence: String
    @Binding var selectedDate: Date
    
    
    
    //MARK: - BODY
    var body: some View {
        List {
            let groupItems = Dictionary(grouping: self.items) {
                Date.getFormattedDate(date: $0.dateAdded, format: .long)
            }.map {
                ($0.key,$0.value)
            }.sorted {
                $0.0 > $1.0
            }
            
            ForEach(groupItems,id: \.self.0) { group in
                
                Section {
                    ForEach(group.1) { item in
                        
                        Button {
                            
                        } label: {
                            HStack{
                                Text(item.type)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text(item.amount.getFormatted(digits: 1) + " \(co2State.listItemsDict[item.type]!.unit)")
                                    Text((item.amount * co2State.listItemsDict[item.type]!.CO2eqkg / co2State.listItemsDict[item.type]!.unitPerKg).getFormatted(digits: 1) + " kg Co2")
                                        .foregroundColor(co2State.getColorForEntry(entry: item))
                                }
                            }
                        }//: buttonLabel
                        
                    }//: foreach for items
                    
                } header: {
                    Text(Date.getFormattedDate(date: group.1[0].dateAdded, format: .long))
                }
                
            }//: group foreach
            
            
        }//: List
    }
}

//struct HistoryListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryListView()
//    }
//}
