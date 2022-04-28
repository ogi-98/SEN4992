//
//  ListItem.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import Foundation

class ListItem: Identifiable {
    let id = UUID()
    let description: String
    let category: String
    let unit: String
    let unitPerKg: Double
    let topCategory: String
    let CO2eqkg: Double
    var searchScore: Double = 0
    let sourceId: Int?

    init(description: String, category: String, CO2eqkg: Double, topCategory: String, unit: String, unitPerKg: Double=1, sourceId: Int? = nil) {
        self.description = description
        self.category = category
        self.unit = unit
        self.unitPerKg = unitPerKg
        self.CO2eqkg = CO2eqkg
        self.topCategory = topCategory
        self.sourceId = sourceId
    }
}
