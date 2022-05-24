//
//  AddView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct AddView: View {
    //MARK: - PROPERTIES
    
    @State private var searchText = ""
    @State var searchResults: [ListItem] = []
    @State var enteredCo2: String = ""
    @State var selectedCategory: String = ""
    @State var selectedItem: ListItem?
    @State var selectedDate: Date = Date()
    
    @EnvironmentObject var co2State: Co2State
    
    
    
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Text("Calculate CO2 Emission")
                .font(.largeTitle)
                .padding(.top)
            HStack{
                SearchBar(text: $searchText, selectedItem: $selectedItem)
                    .padding()
                
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
            if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
    
    
    private var categoryView: some View {
        VStack {
            HStack {
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
