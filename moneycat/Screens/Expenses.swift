//
//  Expenses.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/23.
//

import SwiftUI
import RealmSwift

class Expense: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var amount = 0.0
    @objc dynamic var category = ""
    @objc dynamic var recurrence = ""
    @objc dynamic var date = Date()
    @objc dynamic var note = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

struct ExpensesView: View {
    let realm = try! Realm()
    let expenseAmounts: [Double] // Add this property

    var expenses: Results<Expense> {
        realm.objects(Expense.self)
    }

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Pass expenseAmounts to BarChart
                BarChart(data: expenseAmounts)
                Spacer()
                NavigationLink(destination: Add()) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 45))
                        .padding()
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
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
        // Since Expenses_Previews previews ExpensesView, let's pass some sample data to it
        let sampleData: [Double] = [100, 200, 150, 300]
        return ExpensesView(expenseAmounts: sampleData)
    }
}
