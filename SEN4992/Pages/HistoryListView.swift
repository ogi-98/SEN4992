//
//  HistoryListView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 26.05.2022.
//

import SwiftUI

struct HistoryListView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2Model : Co2Model
    
    var items: [Entry]
    @Binding var selectedItem: Entry?
    @Binding var enteredCo2: String
    @Binding var selectedRecurrence: String
    @Binding var selectedDate: Date
    
    
    
    //MARK: - BODY
    var body: some View {
        List {
            let groupItems = Dictionary(grouping: items) {
                Date.getFormattedDate(date: $0.dateAdded, format: "YYYYMMdd")
            }.map {
                ($0.key,$0.value)
            }.sorted {
                $0.0 > $1.0
            }

            ForEach(groupItems,id: \.self.0) { group in

                Section {
                    ForEach(group.1) { item in

                        Button {
                            withAnimation {
                                selectedItem(item: item)
                            }
                        } label: {
                            VStack {
                                HStack{
                                    Text(item.type)

                                    Spacer()

                                    VStack(alignment: .trailing) {
                                        Text(item.amount.getFormatted(digits: 1) + " \(co2Model.itemsListDict[item.type]!.unit)")
                                        Text((item.amount * co2Model.itemsListDict[item.type]!.CO2eqkg / co2Model.itemsListDict[item.type]!.unitPerKg).getFormatted(digits: 1) + " kg CO2")
                                            .foregroundColor(co2Model.getColorForEntry(entry: item))
                                    }
                                }
                                RecommendLabel(userkWh: item.amount, category: item.category)
                            }//: vstack
                            
                        }//: buttonLabel
                        .listRowBackground(Color("CardViewDynamicColor"))
                    }//: foreach for items

                } header: {
                    Text(Date.getFormattedDateStyle(date: group.1[0].dateAdded, format: .medium))
                        .foregroundColor(Color.white)
                }

            }//: group foreach

        }//: List
    }
    //MARK: - Funcs
    
    private func selectedItem(item: Entry) {
        selectedItem = item
        selectedRecurrence = item.recurrence
        enteredCo2 = (item.amount * Co2Model.recurrenceToDays(item.recurrence)).getFormatted(digits: 1)
        
        selectedDate = item.dateAdded
        if item.recurrence != "1" {
            for entry in co2Model.addedItems {
                if entry.recurrenceID == item.recurrenceID && entry.dateAdded < selectedDate {
                    selectedDate = entry.dateAdded
                }
            }
        }
    }
}

struct RecommendLabel: View {
    @State var userkWh: Double
    @State var category: String
    @State private var userMWh: Double = 0.0
    @State private var calculatedUnrenewable: Double = 0.0
    @State private var calculatedRenewable: Double = 0.0
    @State private var percentage: Double = 0.0
    private let unrenewableParameter = 0.7258
    private let renewableParameter = 0.6482
    @State private var rotateWindMill = false
    
    var body: some View {
        VStack {
            if category.trimmingCharacters(in: .whitespacesAndNewlines) == "Power" {
                HStack(spacing:2) {
                    
                    ZStack{
                        Image("windmill")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .center)
                            .rotationEffect(.degrees(rotateWindMill ? 360*4*4 : 0))
                            .animation(Animation.easeInOut(duration: 4*4).repeatForever(autoreverses: false), value: rotateWindMill)
                            .onAppear {
                                rotateWindMill = true
                            }
                            .onDisappear {
                                rotateWindMill = false
                            }
                    }
                    HStack(spacing: 2) {
                        Text("Wind Turbine or Solar: ")
                            .font(.footnote)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        Spacer()
                        Text("% \(percentage.getFormatted(digits: 1))")
                            .foregroundColor(.green)
                            .onAppear {
                                percentage = yuzdeHesapla()
                            }
                    }
                }
            }//: if
        }//: vstack
    }
    
    private func yuzdeHesapla() -> Double {
        var yuzde = 0.0
        userMWh = userkWh * 0.001
        calculatedUnrenewable = userMWh * unrenewableParameter
        calculatedRenewable = userMWh * renewableParameter
        yuzde = ((calculatedUnrenewable - calculatedRenewable) / calculatedRenewable) * 100
        return yuzde
    }
    
    
    
}

struct RecommendLabel_Previews: PreviewProvider {
    static var previews: some View {
        RecommendLabel(userkWh: 115, category: "Power")
            .preferredColorScheme(.light)
    }
}

//struct HistoryListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryListView()
//    }
//}
