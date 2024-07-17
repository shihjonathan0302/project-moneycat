//
//  ExpensesList.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/24.
//

import SwiftUI
import RealmSwift

class Expense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var amount: Double
    @Persisted var category: ExpenseCategory?  // Marked as optional
    @Persisted var recurrence: String
    @Persisted var date: Date
    @Persisted var note: String
}


class ExpenseCategory: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var name: String
    @Persisted var color: String
}

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
                                Text(expense.category?.name ?? "No Category")  // Handle optional category
                                Text(String(format: "%.2f", expense.amount))
                            }
                        }
                    }
                }
            }
        }
    }
}

func parseDate(_ dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: dateString) ?? Date()
}

struct ExpensesList_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCategory = ExpenseCategory(value: ["name": "Groceries", "color": "blue"])
        let sampleExpenses: [Dictionary<String, [Expense]>.Element] = [
            ("2023-07-12", [Expense(value: ["amount": 10.0, "category": sampleCategory, "recurrence": "None", "date": Date(), "note": "Milk"])])
        ]
        return ExpensesList(expenses: sampleExpenses)
    }
}
