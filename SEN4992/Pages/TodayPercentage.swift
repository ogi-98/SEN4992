//
//  TodayPercentage.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct TodayPercentage: View {
    @EnvironmentObject var co2State: Co2State
    
//    var co2progress = 2.5
//    @State var cappedCo2progress = 3.5
    
    
    private var co2progress: Double {
        get {return Double(self.co2State.currentCo2State/self.co2State.co2max)}
    }

    private var cappedCo2progress: Double {
        get {
            return min(co2progress, 1.0)
        }
    }
    
    
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Todays Footprint")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            ZStack {
                Image("earth-green")
                    .resizable()
                    .scaledToFit()
                Image(co2progress >= 2 ? "death-star" : "earth-burning")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .opacity(Double(CGFloat(cappedCo2progress)))
//                    .frame(height: CGFloat(100*cappedCo2progress), alignment: .bottomLeading)
                    .clipped()
//                    .offset(y: CGFloat(100-cappedCo2progress*100 - 100))
            }
            .frame(width: 100.0, height: 100.0)
            .shadow(radius: 15)
            HStack {
                Text(String(Int(co2progress*100)) + " %")
                ZStack {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 40))
                        .offset(y: -5)
                    Text("Co2")
                        .colorInvert()
                }
            }
            .padding(5)
            .font(.headline)
        }
        .padding(10)
//        .padding(.horizontal,50)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        
        
    }
}

struct TodayPercentage_Previews: PreviewProvider {
    static var previews: some View {
//        TodayPercentage()
//            .environmentObject(Co2State(currentCo2State: 30))
//            .preferredColorScheme(.light)
        TodayView()
            .environmentObject(Co2State(currentCo2State: 30))
            .preferredColorScheme(.light)
    }
}
