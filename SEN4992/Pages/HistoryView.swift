//
//  HistoryView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI
import Combine

struct HistoryView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2Model : Co2Model
    
    @State var selectedItem: Entry?
    @State var enteredCo2: String = ""
    @State var selectedRecurrence: String = "1"
    @State var selectedDate: Date = Date()
    enum Fields {
        case editAmount
    }
    @FocusState private var focusedField: Fields?
    @State private var showingDialogDelete = false
    @State private var showingDialogAdd = false
    
    //MARK: - Body
    var body: some View {
        GeometryReader { geo in
            
            VStack {
                if selectedItem != nil {
                    Text("Edit Entry")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                        .foregroundColor(.white)
                    editView
                        .padding(.top)
                    Spacer()
                }else {
                    Text("Emission History")
                        .font(.largeTitle)
                        .padding(.top)
                        .foregroundColor(.white)
                    
                    if !co2Model.addedItems.isEmpty {
                        HistoryListView(items: co2Model.addedItems.reversed(), selectedItem: $selectedItem, enteredCo2: $enteredCo2, selectedRecurrence: $selectedRecurrence, selectedDate: $selectedDate)
                            .environmentObject(co2Model)
                    }else{
                        Image("EmptyHistory")
                            .resizable()
                            .frame(width: geo.size.height * 0.4, height: geo.size.height * 0.4, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                            .background(Color("CardViewDynamicColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.top,50)
                        Text("You haven't done any calculations yet!")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.top)
                        Spacer()
                    }
                        
                }
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity,alignment: .center)
            .background(Color("customDynamicDarkBlue").ignoresSafeArea().onTapGesture {
                if selectedItem != nil {
                    closeEditView()
                }
            })
            
        }
    }
    
    private var editView: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(selectedItem?.type ?? "Empty")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            HStack {
                TextField("Amount", text: $enteredCo2)
                    .focused($focusedField,equals: .editAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10.0)
                    .onReceive(Just(enteredCo2)) { (newValue: String) in
                        self.enteredCo2 = newValue.numericString(allowDecimalSeparator: true)
                    }
                
                Text(co2Model.listItemsDict[selectedItem!.type]?.unit ?? "Unit")
                    .font(.title2)
            }//: hstack
            .padding(.top)
            
            let co2Amount: Double = self.enteredCo2.parseDouble()
            let fotmattedCO2: String = (co2Amount * (co2Model.listItemsDict[selectedItem!.type]!.CO2eqkg) / co2Model.listItemsDict[selectedItem!.type]!.unitPerKg).getFormatted(digits: 3)
            //            let fotmattedCO2: String = "10.0"
            let formattedPercent: String = (co2Amount * co2Model.listItemsDict[selectedItem!.type]!.CO2eqkg / co2Model.listItemsDict[selectedItem!.type]!.unitPerKg / co2Model.co2max * 100).getFormatted(digits: 1)
            //            let formattedPercent: String = "50"
            
            Text("\(fotmattedCO2) kg CO2 (\(formattedPercent)%)")
                .foregroundColor(Color(uiColor: .systemGray2))
            
            DatePicker("Date:", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .labelsHidden()
                .padding(.top)
            
            Picker(selection: $selectedRecurrence, label: Text("Recurrence:")) {
                Text("once").tag("1")
                Text("daily").tag("d")
                Text("weekly").tag("w")
                Text("monthly").tag("m")
                Text("yearly").tag("y")
            }
            .pickerStyle(.segmented)
            
            HStack {
                
                let paddingVal: CGFloat = 10
                
                Button {
                    showingDialogAdd = true
                } label: {
                    Text("Save")
                        .padding(paddingVal)
                        .frame(maxWidth: .infinity)
                }
                .confirmationDialog("Are you sure to Save?", isPresented: $showingDialogAdd,titleVisibility: .visible) {
                    Button("Save") {
                        withAnimation {
                            guard let savingItem = selectedItem else {
                                return
                            }
                            saveItem(item: savingItem)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
                
                
                Button {
                    showingDialogDelete = true
                    
                } label: {
                    Text("Delete")
                        .padding(paddingVal)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                }
                .confirmationDialog("Are you sure?", isPresented: $showingDialogDelete,titleVisibility: .visible) {
                    
                    Button("Delete",role: .destructive) {
                        withAnimation {
                            guard let deletingItem = selectedItem else {
                                return
                            }
                            deleteItem(item: deletingItem)
                        }
                    }
                    
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
                
            }
            .padding(.top)
            .fixedSize(horizontal: false, vertical: true)
            
            
        }//: Vstack
        .padding()
        .background(
            Color("CardViewDynamicColor")
                .onTapGesture {
                    focusedField = nil
                }
        )
        .cornerRadius(16)
        .shadow(color: .white, radius: 3, x: 0, y: 0)
        .padding(.horizontal, 28)
    }
    
    private func saveItem(item: Entry) {
        if item.recurrence == "1" {
            item.amount = self.enteredCo2.numericString(allowDecimalSeparator: true).parseDouble()
            item.dateAdded = selectedDate
        } else {
            // remove all
            co2Model.addedItems.removeAll { (e: Entry) -> Bool in
                return e.recurrenceID == item.recurrenceID
            }
            // add again
            self.co2Model.addEntry(item: self.co2Model.listItemsDict[item.type]!, amount: self.enteredCo2.numericString(allowDecimalSeparator: true).parseDouble(), dateAdded: selectedDate, recurrence: selectedRecurrence)
        }
        self.selectedItem = nil
        self.enteredCo2 = ""
        co2Model.update()
    }
    
    private func deleteItem(item: Entry){
        co2Model.addedItems.removeAll { (e: Entry) -> Bool in
            return e.recurrenceID != -1 ? item.recurrenceID == e.recurrenceID : item.id == e.id
        }
        selectedItem = nil
        self.enteredCo2 = ""
        co2Model.update()
    }
    
    private func closeEditView() {
        withAnimation {
            enteredCo2 = ""
            selectedItem = nil
            focusedField = nil
        }
    }
    
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
