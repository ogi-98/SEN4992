//
//  Extensions.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 3.04.2022.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}


var customAnimationDuration = false


extension Date {
    func dayDiff(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
     static func getFormattedDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    static func getFormattedDateStyle(date: Date, format: DateFormatter.Style) -> String {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = format
       return dateFormatter.string(from: date)
   }
}


extension String {
    func numericString(allowDecimalSeparator: Bool) -> String {
        // sanitize inputs removes non nubers and all decimal separators after the first
        let sep: String = Locale.current.decimalSeparator ?? "."
        var hasFoundDecimal = false
        return self.filter {
            if $0.isWholeNumber {
                return true
            } else if allowDecimalSeparator && String($0) == sep {
                defer { hasFoundDecimal = true }
                return !hasFoundDecimal
            }
            return false
        }
            
    }
    
    func parseDouble() -> Double {
        let formatter = NumberFormatter()
        return Double(truncating: formatter.number(from: self) ?? 0)
    }

}

extension Double {
    func getFormatted(digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(value: self) ) ?? (formatter.string(from: 0.0)!)
    }
}
