//
//  Period.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/7.
//

import Foundation
import RealmSwift

enum Period: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
