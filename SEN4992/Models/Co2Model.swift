//
//  Co2Model.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import Foundation
import SwiftUI


final class Co2Model: ObservableObject {
    // MARK: Gerneral Co2 model data
    @Published var currentCo2: Double = 10.0
    @Published var co2max = 13.6
    @Published var co2HistoryData: [Double] = [] //[8, 23, 54, 32, 12, 37, 7, 23, 43]
    @Published var co2categoryTotal: [String: Double] = [:] //["Home": 8, "Gas" :23]

    // MARK: History data
    @Published var addedItems: [Entry] = []
    

    var co2data: [String: Any]
    var itemsList: [ItemList] = []
    var itemsListDict: [String: ItemList] = [:]
    
    // Top categories: Home Gas

    func loadItems() {
        // MARK: New Items to add to our Data
        
        //MARK: NATURAL GAS
        itemsList.append(ItemList(description: "🏭🇹🇷 TR Natural Gas", category: "Gas", CO2eqkg: 0.234, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇪🇺 EU Natural Gas", category: "Gas", CO2eqkg: 0.309, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇨🇭 CH Natural Gas", category: "Gas", CO2eqkg: 0.012, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇩🇪 DE Natural Gas", category: "Gas", CO2eqkg: 0.320, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇳🇴 N Natural Gas", category: "Gas", CO2eqkg: 0.004, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇦🇹 Ö Natural Gas", category: "Gas", CO2eqkg: 0.210, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇫🇷 FR Natural Gas", category: "Gas", CO2eqkg: 0.042, topCategory: "Gas", unit: "cm3"))
        itemsList.append(ItemList(description: "🏭🇮🇹 IT Natural Gas", category: "Gas", CO2eqkg: 0.269, topCategory: "Gas", unit: "cm3"))
        // MARK: HOME
        itemsList.append(ItemList(description: "⚡️🇹🇷 TR Electricity", category: "Power", CO2eqkg: 0.555, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇪🇺 EU Electricity", category: "Power", CO2eqkg: 0.300, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇨🇭 CH Electricity", category: "Power", CO2eqkg: 0.024, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇩🇪 DE Electricity", category: "Power", CO2eqkg: 0.480, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇳🇴 N Electricity", category: "Power", CO2eqkg: 0.008, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇦🇹 Ö Electricity", category: "Power", CO2eqkg: 0.166, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇫🇷 FR Electricity", category: "Power", CO2eqkg: 0.064, topCategory: "Home", unit: "kWh", sourceId: 1))
        itemsList.append(ItemList(description: "⚡️🇮🇹 IT Electricity", category: "Power", CO2eqkg: 0.350, topCategory: "Home", unit: "kWh", sourceId: 1))
        

        
        for item in itemsList {
            itemsListDict[item.description] = item
        }
    }
    
    init(currentCo2State: Double = 0.0) {
        self.currentCo2 = currentCo2State
        co2data = Co2Model.readJSONFromFile(fileName: "Co2") as? [String: Any] ?? [:]
        loadItems()

        // Load added items from UserDefaults
        let value = UserDefaults.standard.object(forKey: "addedItems") as? Data
        if value != nil {
            addedItems = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value!) as? [Entry] ?? []
        } else {
        }
        update()
    }

    func update() {
        updateRecurrentEntries()
        saveEntries()
        updateCurrentCo2()
        co2HistoryData = getCo2PerDay()
        co2categoryTotal = getCo2CategoryTotal()
    }
    
    func updateRecurrentEntries() {
        var lastRecurrentEntries: [Int: Entry] = [:]
        for entry in addedItems {
            if entry.recurrence == "1" {
                continue
            }
            if lastRecurrentEntries[entry.recurrenceID] == nil || lastRecurrentEntries[entry.recurrenceID]!.dateAdded < entry.dateAdded {
                lastRecurrentEntries[entry.recurrenceID] = entry
                continue
            }
        }
        for (_, entry) in lastRecurrentEntries {
            // add seconds to Date() to fix timezone
            var date = entry.dateAdded.addingTimeInterval(Double(TimeZone.current.secondsFromGMT()))
            while date.dayDiff(Date().addingTimeInterval(Double(TimeZone.current.secondsFromGMT()))) >= 0 {
                date = date.addingTimeInterval(24*60*60)
                let newEntry = Entry(category: entry.category, type: entry.type, amount: entry.amount, dateAdded: date, recurrence: entry.recurrence, recurrenceID: entry.recurrenceID)
                addedItems.append(newEntry)
            }
        }
    }


    func getCo2CategoryTotal() -> [String: Double] {
        var catTotal: [String: Double] = ["Food": 0, "Gas": 0, "Clothes": 0, "Home": 0]
        for entry in addedItems {
            let item = itemsListDict[entry.type]!
            let cat = item.topCategory
            catTotal[cat] = entry.amount * item.CO2eqkg / item.unitPerKg + (catTotal[cat] ?? 0)
        }
        return catTotal
    }

    func updateCurrentCo2() {
        var co2: Double = 0
        for item in addedItems {
            if item.dateAdded.dayDiff(Date()) == 0 {
                co2 += itemsListDict[item.type]!.CO2eqkg * item.amount / itemsListDict[item.type]!.unitPerKg
            }
        }
        currentCo2 = co2
    }

    func getCo2PerDay(category: String = "", n_days: Int = 10) -> [Double] {
        var co2Stats: [Int: Double] = [:]
        for item in addedItems {
            let daysDiff = item.dateAdded.dayDiff(Date())
            co2Stats[daysDiff] = itemsListDict[item.type]!.CO2eqkg * item.amount / itemsListDict[item.type]!.unitPerKg + (co2Stats[daysDiff] ?? 0)
        }
        var result: [Double] = []
        for i in 0..<n_days {
            result.append(co2Stats[n_days - i - 1] ?? 0)
        }
        return result
    }

    func getColorForItem(item: ItemList) -> Color {
        let colors = [Color.green, Color.green, Color.yellow, Color.orange, Color.red, Color(red: 0.85, green: 0, blue: 0)]
        let catItems = itemsList.filter { (listItem) -> Bool in
            return listItem.topCategory == item.topCategory
        }.map { (listItem) -> Double in
            listItem.CO2eqkg
        }
        var n_higher: Double = 0
        for catItem in catItems {
            if item.CO2eqkg < catItem {
                n_higher += 1
            }
        }
        let score = 1 - n_higher / Double(catItems.count)
        let i = Int(min(score, 0.99) * Double(colors.count))
        return colors[i]
    }

    func getColorForEntry(entry: Entry) -> Color {
        let colors = [Color.green, Color.yellow, Color.orange, Color.red, Color(red: 0.85, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)]
        let score = min(entry.amount * itemsListDict[entry.type]!.CO2eqkg / itemsListDict[entry.type]!.unitPerKg / co2max, 1)
        let i = Int(min(score, 0.99) * Double(colors.count))
        return colors[i]
    }

    func saveEntries() {
        let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: addedItems, requiringSecureCoding: false)
        UserDefaults.standard.set(encodedData, forKey: "addedItems")

    }

    func addEntry(item: ItemList, amount: Double, dateAdded: Date, recurrence: String) {
        let recurrenceID = UserDefaults.standard.integer(forKey: "recurrenceID")
        UserDefaults.standard.setValue(recurrenceID+1, forKey: "recurrenceID")
        let dailyAmount = amount / Co2Model.recurrenceToDays(recurrence)  // 60/30
        let entry = Entry(category: item.category, type: item.description, amount: dailyAmount, dateAdded: dateAdded, recurrence: recurrence, recurrenceID: recurrenceID)
        addedItems.append(entry)
        update()
    }
    
    static func recurrenceToDays(_ recurrence: String) -> Double {
        return recurrence == "y" ? 365 : recurrence == "m" ? 30 : recurrence == "w" ? 7 : 1
    }

    static func readJSONFromFile(fileName: String) -> Any? {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // Handle error here
                print("ERROR")
            }
        }
        return json
    }

    func getSearchResults(query: String?, category: String) -> [ItemList] {
        var items: [ItemList] = itemsList

        if query == nil && category != "" {
            items = items.filter({ (item) -> Bool in
                item.topCategory == category
            })
        }

        if query == nil {
            return items
        }
        
        var filteredArray = items
        if let searchQuery = query {
            filteredArray = filteredArray.filter { $0.description.localizedCaseInsensitiveContains(searchQuery)}
        }        
        return filteredArray
    }
}




