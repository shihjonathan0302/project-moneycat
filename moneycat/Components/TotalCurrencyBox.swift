//
//  TotalCurrencyBox.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/26.
//

import SwiftUI

extension Double {
    func roundTo(_ decimalPlaces: Int) -> Double {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}

struct TotalCurrencyBox: View {
    var amount: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(amount.roundTo(2))")
                .font(.title)
                
            Text("USD")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(Color("color.fill.tertiary"))
        .cornerRadius(6)
    }
}

struct TotalCurrencyBox_Previews: PreviewProvider {
    static var previews: some View {
        TotalCurrencyBox()
    }
}
