//
//  CategoryView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 28.04.2022.
//

import SwiftUI

struct CategoryView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var co2Model: Co2Model
    
    private var categories = ["Home","Food","Clothes","Gas"]
        
    
    //MARK: - BODY
    var body: some View {
        let data = categories.map { (cat) -> Double in
            return co2Model.co2categoryTotal[cat] ?? 0.0
        }

        PieChartView(labels: categories, data: data, title: "Category", style: Styles.pieChartStyleMain)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
            .previewLayout(.sizeThatFits)
            .environmentObject(Co2Model(currentCo2State: 30))
    }
}
