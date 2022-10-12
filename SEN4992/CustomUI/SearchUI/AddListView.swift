//
//  AddListView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 9.05.2022.
//

import SwiftUI

struct AddListView: View {
    var items: [ItemList]
    @Binding var selectedItem: ItemList?
    @EnvironmentObject var co2Model: Co2Model
    var body: some View {
        List(items) { item in
            Button {
                withAnimation {
                    self.selectedItem = item
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(item.description)
                        .foregroundColor(Color(uiColor: .label))
                    Text(item.category)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                    Text("\(item.CO2eqkg.getFormatted(digits: 2)) kgCO2/\(item.unit)")
                        .foregroundColor(co2Model.getColorForItem(item: item))
                        .multilineTextAlignment(.trailing)
                }
            }
            .listRowBackground(Color("CardViewDynamicColor"))
            
        }//: listView
    }
}

struct AddListView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environmentObject(Co2Model(currentCo2State: 30))
    }
}
