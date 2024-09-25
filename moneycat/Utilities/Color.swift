//
//  Color.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/24.
//

import RealmSwift
import SwiftUI

public class PersistableColor: EmbeddedObject {
    @Persisted var red: Double = 0
    @Persisted var green: Double = 0
    @Persisted var blue: Double = 0
    @Persisted var opacity: Double = 1.0
    
    convenience init(color: Color) {
        self.init()
        let uiColor = UIColor(color)
        if let components = uiColor.cgColor.components, components.count >= 3 {
            red = Double(components[0])
            green = Double(components[1])
            blue = Double(components[2])
            opacity = components.count >= 4 ? Double(components[3]) : 1.0
        }
    }
}

extension Color: @retroactive _CustomPersistable {}
extension Color: @retroactive _RealmCollectionValueInsideOptional {}
extension Color: @retroactive RealmCollectionValue {}
extension Color: @retroactive _HasPersistedType {}
extension Color: @retroactive _ObjcBridgeable {}
extension Color: @retroactive _PersistableInsideOptional {}
extension Color: @retroactive _Persistable {}
extension Color: @retroactive _RealmSchemaDiscoverable {}
extension Color: @retroactive CustomPersistable {
    public typealias PersistedType = PersistableColor
    
    public init(persistedValue: PersistableColor) {
        self.init(
            .sRGB,
            red: persistedValue.red,
            green: persistedValue.green,
            blue: persistedValue.blue,
            opacity: persistedValue.opacity
        )
    }
    
    public var persistableValue: PersistableColor {
        return PersistableColor(color: self)
    }
}
