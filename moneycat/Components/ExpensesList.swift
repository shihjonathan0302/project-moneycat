import SwiftUI
import RealmSwift

class Expense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var amount: Double
    @Persisted var category: ExpenseCategory?  // Marked as optional
    @Persisted var recurrence: String
    @Persisted var date: Date
    @Persisted var note: String
    @Persisted var isNeed: Bool  // New property to indicate if the expense is a need
    
}

class ExpenseCategory: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var name: String
    @Persisted var color: String  // Save the color as a String

    var uiColor: UIColor {
        UIColor(hexString: color)
    }

    var swiftUIColor: Color {
        Color(uiColor: uiColor)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let scanner = Scanner(string: hexString)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
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
        let sampleCategory = ExpenseCategory(value: ["name": "Groceries", "color": "#0000FF"])
        let sampleExpenses: [Dictionary<String, [Expense]>.Element] = [
            ("2023-07-12", [Expense(value: ["amount": 10.0, "category": sampleCategory, "recurrence": "None", "date": Date(), "note": "Milk"])])
        ]
        return ExpensesList(expenses: sampleExpenses)
    }
}
