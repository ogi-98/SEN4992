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
                            VStack {
                                HStack{
                                    Text(item.type)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(item.amount.getFormatted(digits: 1) + " \(co2State.listItemsDict[item.type]!.unit)")
                                        Text((item.amount * co2State.listItemsDict[item.type]!.CO2eqkg / co2State.listItemsDict[item.type]!.unitPerKg).getFormatted(digits: 1) + " kg Co2")
                                            .foregroundColor(co2State.getColorForEntry(entry: item))
                                    }
                                }
                                RecommendLabel(userkWh: item.amount, category: item.category)
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
