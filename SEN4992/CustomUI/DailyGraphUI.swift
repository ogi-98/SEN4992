//
//  DailyGraphUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI
import SwiftUICharts

struct DailyGraphUI: View {
    @EnvironmentObject var co2State: Co2State
    
//    let chartSytle = SwiftUICharts.ChartStyle(backgroundColor: Color.white, accentColor: .green, secondGradientColor: .red, textColor: .black, legendTextColor: .gray, dropShadowColor: .gray)
    
    var body: some View {
//        GeometryReader { geometry in
            VStack {
                LineChartViewCustom(data: co2State.co2HistoryData, title: "Your History",legend: "Basic", style: Styles.lineChartStyleOne, form: ChartForm.large, rateValue: Int(co2State.currentCo2State))
//                    .frame(width: geometry.size.width+20)
//                    .offset(x: -10)
//                LineChartView(data: co2State.co2HistoryData, title: "Your history 2", legend: "basic2", style: chartSytle, form: SwiftUICharts.ChartForm.medium, rateValue: Int(co2State.currentCo2State), dropShadow: true)
            }
//        }
    }
}


struct DailyGraphUI_Previews: PreviewProvider {
    static var previews: some View {
        DailyGraphUI()
            .environmentObject(Co2State(currentCo2State: 10.0))
    }
}

