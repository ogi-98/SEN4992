//
//  DailyGraphUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct DailyGraphUI: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2State: Co2State
    
    
    //MARK: - BODY
    var body: some View {
        VStack {
            LineChartViewCustom(data: co2State.co2HistoryData, title: "Your History",legend: "Basic", style: Styles.lineChartStyleOne, form: ChartForm.large, rateValue: Int(co2State.currentCo2State))
        }
    }
}


struct DailyGraphUI_Previews: PreviewProvider {
    static var previews: some View {
        DailyGraphUI()
            .environmentObject(Co2State(currentCo2State: 10.0))
    }
}

