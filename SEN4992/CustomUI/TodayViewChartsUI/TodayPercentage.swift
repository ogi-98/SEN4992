//
//  TodayPercentage.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct TodayPercentage: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2Model: Co2Model
    
//    var co2progress = 0.5
//    @State var cappedCo2progress = 0.5
    @State var style: ChartStyle = Styles.lineChartStyleMain
    
        private var co2progress: Double {
            get {return Double(self.co2Model.currentCo2/self.co2Model.co2max)}
        }
    
        private var cappedCo2progress: Double {
            get {
                return min(co2progress, 1.0)
            }
        }
    
    
    //MARK: - BODY    
    var body: some View {
        
        VStack {
            Text("Todays Footprint")
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            ZStack {
                Image("earth-green")
                    .resizable()
                    .scaledToFit()
                Image(co2progress >= 2 ? "death-star" : "earth-burning")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .opacity(cappedCo2progress)
            }
            .padding(8)
            .shadow(radius: 15)
            HStack {
                Text(String(Int(co2progress*100)) + " %")
                ZStack {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 40))
                        .offset(y: -5)
                    Text("CO2")
                        .colorInvert()
                }
            }
//            .padding(5)
            .font(.headline)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 3)
        .background(style.backgroundColor)
        .foregroundColor(style.textColor)
        .cornerRadius(20)
        .shadow(color: style.dropShadowColor, radius: 3)
        
        
    }
}

struct TodayPercentage_Previews: PreviewProvider {
    static var previews: some View {
        //        TodayPercentage()
        //            .environmentObject(Co2State(currentCo2State: 30))
        //            .preferredColorScheme(.light)
        TodayView()
            .environmentObject(Co2Model(currentCo2State: 30))
            .preferredColorScheme(.light)
    }
}
