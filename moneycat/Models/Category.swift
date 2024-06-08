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
        get {
            if self._color == nil {
                return Color.clear
            }
            return Color(persistedValue: self._color!)
        }
    }
    
    convenience init(name: String, color: Color) {
        self.init()
        self.name = name
        self._color = color.persistableValue
    }
}
