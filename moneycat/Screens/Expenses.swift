//
//  Expenses.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI

struct Expenses: View {
    @EnvironmentObject var realmManager: RealmManager
    var expenses: [Expense]
    
    @State private var totalExpenses: Double = 0
    @State private var filteredExpenses: [Expense] = []
    @State private var searchQuery = ""
    @State private var timeFilter = Period.week
    let columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 96), spacing: 16), count: 3)
    
    func reloadData() {
        filteredExpenses = filterExpensesInPeriod(period: timeFilter, expenses: realmManager.expenses)
        
        totalExpenses = 0
        
        filteredExpenses.forEach { expense in
            totalExpenses += expense.amount
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Text("Total for:")
                    Picker("", selection: $timeFilter) {
                        Text("today").tag(Period.day)
                        Text("this week").tag(Period.week)
                        Text("this month").tag(Period.month)
                        Text("this year").tag(Period.year)
                    }
                    .foregroundColor(.white)
                }
                
                HStack(alignment: .top, spacing: 4) {
                    Text("$")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    Text("\(totalExpenses.roundTo(2))")
                        .font(.largeTitle)
                }
                
                ExpensesList(expenses: groupExpensesByDate(filteredExpenses))
                    .id(filteredExpenses.map { $0.id }) // Ensure id conforms to Hashable
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .navigationTitle("Expenses")
        }
        .searchable(
            text: $searchQuery,
            placement: .automatic,
            prompt: "Search expenses"
        )
        .onChange(of: timeFilter) {
            reloadData()
        }
        .onAppear {
            reloadData()
        }
    }
    
    // Function to filter expenses based on the selected period
    func filterExpensesInPeriod(period: Period, expenses: [Expense]) -> [Expense] {
        let calendar = Calendar.current
        let now = Date()
        
        return expenses.filter { expense in
            switch period {
            case .day:
                return calendar.isDate(expense.date, inSameDayAs: now)
            case .week:
                return calendar.isDate(expense.date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(expense.date, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate(expense.date, equalTo: now, toGranularity: .year)
            }
        }
    }
    
    // Function to group expenses by date
    func groupExpensesByDate(_ expenses: [Expense]) -> [Dictionary<String, [Expense]>.Element] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let grouped = Dictionary(grouping: expenses) { expense in
            dateFormatter.string(from: expense.date)
        }
        
        return Array(grouped)
    }
}

extension Double {
    func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        let realmManager = RealmManager()
        Expenses(expenses: realmManager.expenses)
            .environmentObject(realmManager)
    }
}
