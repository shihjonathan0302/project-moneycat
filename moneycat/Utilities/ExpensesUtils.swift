//
//  ExpensesUtils.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/23.
//

import Foundation
import RealmSwift

class MyAppExpense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var amount: Double = 0.0
    @Persisted var category: Category?
    @Persisted var date: Date = Date()
    @Persisted var note: String?
    @Persisted var recurrence: Recurrence? = Recurrence.none
    
    convenience init(amount: Double, category: Category?, date: Date, note: String? = nil, recurrence: Recurrence? = nil) {
        self.init()
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
        self.recurrence = recurrence
    }
    
    var dayInWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self.date)
    }
    
    var dayInMonth: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return Int(dateFormatter.string(from: self.date)) ?? 0
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self.date)
    }
    
    var year: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return Int(dateFormatter.string(from: self.date)) ?? 0
    }
}
