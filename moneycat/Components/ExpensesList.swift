//
//  ExpensesList.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/24.
//

import SwiftUI

struct ExpensesList: View {
    var expenses: [Dictionary<String, [Expense]>.Element]
    
    func getHeaderText(_ date: String) -> String {
        let headerDate = parseDate(date)
        
        if Calendar.current.isDateInToday(headerDate) {
            return "Today"
        }
        
        if Calendar.current.isDateInYesterday(headerDate) {
            return "Yesterday"
        }
        
        return date
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(Array(expenses), id: \.key) { (key: String, value: [Expense]) in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(getHeaderText(key))")
                                .font(.headline)
                        }
                        ForEach(value) { expense in
                            HStack {
                                Text(expense.note)
                                Spacer()
                                Text(String(format: "%.2f", expense.amount))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Expense: Identifiable {
    var id = UUID()
    var amount: Double
    var category: String
    var recurrence: String
    var date: Date
    var note: String
}

func parseDate(_ dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: dateString) ?? Date()
}

struct ExpensesList_Previews: PreviewProvider {
    static var previews: some View {
        let sampleExpenses: [Dictionary<String, [Expense]>.Element] = [
            ("2023-07-12", [Expense(amount: 10.0, category: "Groceries", recurrence: "None", date: Date(), note: "Milk")])
        ]
        return ExpensesList(expenses: sampleExpenses)
    }
}
