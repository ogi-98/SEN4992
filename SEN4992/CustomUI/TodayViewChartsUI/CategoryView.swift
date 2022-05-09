//
//  CategoryView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 28.04.2022.
//

import SwiftUI

struct CategoryView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2State: Co2State
    
    private var categories = ["Home","Food","Clothes","Transportation"]
        
    
    //MARK: - BODY
    var body: some View {
        let data = categories.map { (cat) -> Double in
            return co2State.co2categoryTotal[cat] ?? 0.0
        }

//        PieChartView(labels: categories, data: data, title: "Total CO2 per Categories", legend: "KG CO2", form: ChartForm.medium, dropShadow: true)
        PieChartView(labels: categories, data: data, title: "Category")
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
            .previewLayout(.sizeThatFits)
            .environmentObject(Co2State(currentCo2State: 30))
    }
}
