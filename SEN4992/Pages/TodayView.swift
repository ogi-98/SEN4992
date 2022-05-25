//
//  TodayView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct TodayView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2State: Co2State

    
    
    
    
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(spacing:0){
                
                HStack{
                    VStack(alignment: .leading){
                        Text("20.03.2022")
                            .foregroundColor(.secondary)
                            .font(.callout)
                        
                        Text("Good Afternoon, (isim)")
                            .foregroundColor(Color(uiColor: .label))
                            .font(.headline)
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                    
                    NavigationLink {
                        UserSettings()
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                            .foregroundColor(Color(uiColor: .label))
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }


                }//: hstack
                .padding(.horizontal)
                
                DailyGraphUI()
                    .padding()
                
                HStack {
                    TodayPercentage()
                        .frame(maxHeight:.infinity)
    //                TodayPercentage()
                    CategoryView()
                        .frame(maxHeight:.infinity)

                        
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.bottom)
                
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
            .navigationBarHidden(true)
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(Co2State(currentCo2State: 30))
            .preferredColorScheme(.light)
    }
}
