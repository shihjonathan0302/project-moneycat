//
//  TotalCurrencyBox.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/26.
//

import SwiftUI

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
