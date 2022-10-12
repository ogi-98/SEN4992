//
//  Entry.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import Foundation

class Entry: NSObject, Identifiable, ObservableObject, NSCoding {
    let id = UUID()
    var category: String
    var type: String
    var amount: Double
    var dateAdded: Date
    var recurrence: String
    var recurrenceID: Int

    init(category: String, type: String, amount: Double, dateAdded: Date, recurrence: String = "1", recurrenceID: Int = -1) {
        self.category = category
        self.type = type
        self.amount = amount
        self.dateAdded = dateAdded
        self.recurrence = recurrence
        self.recurrenceID = recurrenceID
    }

    func encode(with coder: NSCoder) {
        coder.encode(category, forKey: "category")
        coder.encode(type, forKey: "type")
        coder.encode(amount, forKey: "amount")
        coder.encode(dateAdded, forKey: "dateAdded")
        coder.encode(recurrence, forKey: "recurrence")
        coder.encode(recurrenceID, forKey: "recurrenceID")
    }

    required init(coder: NSCoder) {
        category = coder.decodeObject(forKey: "category") as! String
        type = coder.decodeObject(forKey: "type") as! String
        amount = coder.decodeDouble(forKey: "amount")
        dateAdded = coder.decodeObject(forKey: "dateAdded") as! Date
        recurrence = coder.decodeObject(forKey: "recurrence") as! String
        recurrenceID = coder.decodeInteger(forKey: "recurrenceID")
    }

}
