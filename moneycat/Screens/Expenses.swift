//
//  Categories.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI

struct ExpensesView: View {
    @EnvironmentObject var viewModel: ExpensesViewModel
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            VStack {
                BarChart(data: viewModel.expenseAmounts)
                Spacer() // Pushes the button to the bottom
                Button(action: {
                    showingAddExpense.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 45))
                        .padding()
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingAddExpense) {
                    Add().environmentObject(viewModel)
                }
            }
            .navigationTitle("Expenses")
        }
    }
}

struct BarChart: View {
    let data: [Double]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(data, id: \.self) { value in
                VStack {
                    Spacer(minLength: 0)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: CGFloat(value * 10))
                }
            }
        }
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
            .environmentObject(ExpensesViewModel())
    }
}
