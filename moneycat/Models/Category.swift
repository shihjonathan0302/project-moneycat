//
//  Category.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/8.
//

import SwiftUI
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted private var _color: PersistableColor?
    @Persisted var name: String
    
    var color: Color {
        if let color = self._color {
            return Color(persistedValue: color)
        }
        return Color.clear
    }
    
    convenience init(name: String, color: Color) {
        self.init()
        self.name = name
        self._color = color.persistableValue
    }

    // Predefined categories
    static let groceries = Category(name: "Groceries", color: .green)
    static let bills = Category(name: "Bills", color: .red)
    static let subscriptions = Category(name: "Subscriptions", color: .blue)
    static let gas = Category(name: "Gas", color: .yellow)
}
