//
//  Expenses.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/23.
//

import SwiftUI
import RealmSwift

class Expense: Object, Identifiable {
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

class ExpensesViewModel: ObservableObject {
    private var realm: Realm
    @Published var expenses: Results<Expense>
    @Published var expenseAmounts: [Double] = []

    init() {
        do {
            realm = try Realm()
            expenses = realm.objects(Expense.self)
            calculateExpenseAmounts()
        } catch {
            fatalError("Failed to open Realm: \(error)")
        }
    }

    private func calculateExpenseAmounts() {
        expenseAmounts = expenses.map { $0.amount }
    }

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}

struct ExpensesView: View {
    @StateObject private var viewModel = ExpensesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                BarChart(data: viewModel.expenseAmounts)
                Spacer()
                NavigationLink(destination: Add()) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 45))
                        .padding()
                        .foregroundColor(.blue) // Changed to blue for better visibility
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
        let sampleData: [Double] = [100, 200, 150, 300]
        return ExpensesView().environmentObject(ExpensesViewModel())
    }
}
