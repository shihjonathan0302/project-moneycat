//
//  Double.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/29.
//

import Foundation

extension Double {
    func roundTo(_ maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."
        if let formattedNumber = formatter.string(from: NSNumber(value: self)) {
            return formattedNumber
        }
        return String(format: "%.\(maximumFractionDigits)f", self)
    }
}
