//
//  SearchBar.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 9.05.2022.
//

import SwiftUI

struct SearchBar: View {
    //MARK: - PROPERTIES
    @Binding var text: String
    @Binding var selectedItem: ListItem?

    @State private var isEditing = false
    
    //MARK: - BODY
    var body: some View {
        HStack {
            
            TextField("Search", text: $text)
                .padding(5)
                .padding(.horizontal,20)
                .background(
                    Color(uiColor: .systemGray6)
                )
                .cornerRadius(8)
                .overlay {
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading,4)
                        if !text.isEmpty {
                            Button {
                                withAnimation {
                                    self.text = ""
                                }
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color(uiColor: .opaqueSeparator))
                                    .padding(.trailing, 8)
                            }

                        }
                    }
                }//: overlay
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing && false {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                        self.selectedItem = nil
                    }
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }

            
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
