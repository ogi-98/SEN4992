//
//  DailyGraphUI.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct DailyGraphUI: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2Model: Co2Model
    
    
    //MARK: - BODY
    var body: some View {
        VStack {
            LineChartViewCustom(data: co2Model.co2HistoryData, title: "Your History",legend: "Basic", style: Styles.lineChartStyleMain, form: ChartForm.large, rateValue: Int(co2Model.currentCo2))
        }
    }
}


struct DailyGraphUI_Previews: PreviewProvider {
    static var previews: some View {
        DailyGraphUI()
            .environmentObject(Co2Model(currentCo2State: 10.0))
    }
}

