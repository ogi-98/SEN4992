//
//  AddView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI
import Combine

struct AddView: View {
    //MARK: - PROPERTIES
    
    @State private var searchText = ""
    @State var searchResults: [ListItem] = []
    @State var enteredCo2: String = ""
    @State var selectedCategory: String = ""
    @State var selectedItem: ListItem?
    @State var selectedDate: Date = Date()
    @State var selectedRecurrence: String = "1"
    
    @EnvironmentObject var co2State: Co2State
    
    
    
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Text("Calculate CO2 Emission")
                .font(.largeTitle)
                .padding(.top,30)
            HStack{
                SearchBar(text: $searchText, selectedItem: $selectedItem)
                    .padding(.horizontal)
                
                if selectedItem != nil || selectedCategory != "" || searchText != "" {
                    Button {
                        withAnimation {
                            selectedCategory = ""
                            selectedItem = nil
                            searchText = ""
                            enteredCo2 = ""
                        }
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Text("Back")
                    }
                    .offset(x: -20)
                    //.padding(.trailing, 20)
                    .transition(.move(edge: .trailing))
                    .animation(.default)

                }
            }//: hstack
            if !(selectedItem != nil || selectedCategory != "" || searchText != "") {
                Spacer().frame(minHeight: 0, maxHeight: 80)
            }
            
            // show item & add screen
            if selectedItem != nil {
                
                addView
                
                
            }else if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                AddListView(items: co2State.getSearchResults(query: self.searchText.trimmingCharacters(in: .whitespacesAndNewlines), category: self.selectedCategory), selectedItem: $selectedItem)
            }else if !selectedCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                AddListView(items: co2State.getSearchResults(query: nil, category: self.selectedCategory), selectedItem: $selectedItem)
                    .environmentObject(co2State)
            }else{
                categoryView
            }
            
            
            
            
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity,alignment: .top)
    }
    
    
    private var addView: some View {
            VStack(alignment: .center, spacing: 20) {
                Text("Electricity")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                HStack {
                    TextField("Amount", text: $enteredCo2)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10.0)
                        .onReceive(Just(enteredCo2)) { (newValue: String) in
                            self.enteredCo2 = newValue.numericString(allowDecimalSeparator: true)
                        }
                    
                    Text("kwH")
                        .font(.title2)
                }//: hstack
                .padding(.top)
                
                let co2Amount: Double = self.enteredCo2.parseDouble()
    //                    let fotmattedCO2: String = (co2Amount * selectedItem!.CO2eqkg / selectedItem!.unitPerKg).getFormatted(digits: 3)
                let fotmattedCO2: String = "10.0"
    //                    let formattedPercent: String = (co2amount * selectedItem!.CO2eqkg / selectedItem!.unitPerKg / co2State.co2max * 100).getFormatted(digits: 1)
                let formattedPercent: String = "50"
                
                Text("\(fotmattedCO2) kg CO2 (\(formattedPercent)%)")
                    .foregroundColor(Color(uiColor: .systemGray2))
                
                DatePicker("Date:", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    .labelsHidden()
                    .padding(.top)
                
                Picker(selection: $selectedRecurrence, label: Text("Recurrence:")) {
                    Text("once").tag("1")
                    Text("daily").tag("d")
                    Text("weekly").tag("w")
                    Text("month").tag("m")
                    Text("yearly").tag("y")
                }
                .pickerStyle(.segmented)
                
                HStack {
                    
                    let paddingVal: CGFloat = 10
                    
                    Button {
                        
                    } label: {
                        Text("Add")
                            .padding(paddingVal)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    
                    
                    Button {
                        
                    } label: {
                        Text("Cancel")
                            .padding(paddingVal)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)

                    
                }
                .padding(.top)
                .fixedSize(horizontal: false, vertical: true)
                
                
            }//: Vstack
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: .gray, radius: 3, x: 0, y: 0)
            .padding(.horizontal, 28)
        }
    
    private var categoryView: some View {
        VStack {
            HStack {
                
                Button {
                    withAnimation {
                        self.selectedCategory = "Home"
                    }
                } label: {
                    VStack {
                        Text("🏡")
                            .font(.system(size: 70))
                        Text("Home")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color(uiColor: .label))
                    .frame(maxWidth:.infinity, maxHeight:.infinity)
                }//: bttn
//                    .tint(.blue)
                .buttonStyle(.bordered)

                Button {
                    withAnimation {
                        self.selectedCategory = "Transport"
                    }
                } label: {
                    VStack {
                        Text("🚘")
                            .font(.system(size: 70))
                        Text("Transportation")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color(uiColor: .label))
                    .frame(maxWidth:.infinity, maxHeight:.infinity)
                }//: bttn
//                    .tint(.blue)
                .buttonStyle(.bordered)
                
                
            }
            .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Button {
                    withAnimation {
                        self.selectedCategory = "Food"
                    }
                } label: {
                    ZStack {
                        VStack {
                            Text("🍔")
                                .font(.system(size: 70))
                            Text("Food")
                                .fontWeight(.bold)
                        }
//                      .foregroundColor(Color(uiColor: .label))
                        .frame(maxWidth:.infinity, maxHeight:.infinity)
                        
                        Text("Coming Soon")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(7)
                            .foregroundColor(Color(uiColor: .label))
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(10)
                            .rotationEffect(.degrees(-20))

                    }
                }//: bttn
//                    .tint(.blue)
                .buttonStyle(.bordered)
                .disabled(true)
                
                Button {
                    withAnimation {
                        self.selectedCategory = "Clothes"
                    }
                } label: {
                    ZStack {
                        VStack {
                            Text("👔")
                                .font(.system(size: 70))
                            Text("Clothes")
                                .fontWeight(.bold)
                        }
    //                  .foregroundColor(Color(uiColor: .label))
                        .frame(maxWidth:.infinity, maxHeight:.infinity)
                        
                        Text("Coming soon")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(7)
                            .foregroundColor(Color(uiColor: .label))
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(10)
                            .rotationEffect(.degrees(-20))

                    }
                }//: bttn
//                    .tint(.blue)
                .buttonStyle(.bordered)
                .disabled(true)

            }
            .fixedSize(horizontal: false, vertical: true)
            
        }//: categoryView
        .padding(.horizontal)
    }
    
    
    
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environmentObject(Co2State(currentCo2State: 30))
            .preferredColorScheme(.light)
    }
}
