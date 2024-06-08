//
//  ExpensesList.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/24.
//

//import SwiftUI
//import RealmSwift
//
//class Expense: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var amount: Double = 0.0
//    @Persisted var category: Category?
//    @Persisted var date: Date
//    @Persisted var note: String?
//    @Persisted var recurrence: Recurrence? = Recurrence.none
//    
//    convenience init(amount: Double, category: Category, date: Date, note: String? = nil, recurrence: Recurrence? = nil) {
//        self.init()
//        self.amount = amount
//        self.category = category
//        self.date = date
//        self.note = note
//        self.recurrence = recurrence
//    }
//}
//
//class Category: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var name: String
//    @Persisted var colorHex: String
//    
//    var color: Color {
//        return Color(hex: colorHex)
//    }
//    
//    convenience init(name: String, colorHex: String) {
//        self.init()
//        self.name = name
//        self.colorHex = colorHex
//    }
//}
//
//enum Recurrence: String, PersistableEnum {
//    case none
//    case daily
//    case weekly
//    case monthly
//    case yearly
//}
//
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int = UInt64()
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3:
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6:
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8:
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (255, 0, 0, 0)
//        }
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue: Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}
//
//func parseDate(_ date: String) -> Date {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    return dateFormatter.date(from: date) ?? Date()
//}
//
//func formatDate(_ date: Date, format: String) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = format
//    return dateFormatter.string(from: date)
//}
//
//struct Tag: View {
//    let label: String
//    let color: Color
//    
//    var body: some View {
//        Text(label)
//            .padding(4)
//            .background(color)
//            .foregroundColor(.white)
//            .cornerRadius(4)
//    }
//}
//
//struct ExpensesList: View {
//    var expenses: [Dictionary<String, [Expense]>.Element]
//    
//    func getHeaderText(_ date: String) -> String {
//        let headerDate = parseDate(date)
//        
//        if Calendar.current.isDateInToday(headerDate) {
//            return "Today"
//        }
//        
//        if Calendar.current.isDateInYesterday(headerDate) {
//            return "Yesterday"
//        }
//        
//        return date
//    }
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(alignment: .leading, spacing: 24) {
//                ForEach(Array(expenses), id: \.key) { key, value in
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack(alignment: .firstTextBaseline) {
//                            Text("\(getHeaderText(key))")
//                                .font(.headline)
//                                .foregroundColor(.secondary)
//                            
//                            Spacer()
//                            
//                            Text("USD \(value.map { $0.amount }.reduce(0, +).roundTo(2))")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        Divider()
//                        
//                        ForEach(value, id: \._id) { expense in
//                            VStack(spacing: 4) {
//                                HStack {
//                                    Text(expense.note ?? expense.category!.name)
//                                        .font(.headline)
//                                    
//                                    Spacer()
//                                    
//                                    Text("USD \(expense.amount.roundTo(2))")
//                                }
//                                HStack {
//                                    Tag(label: expense.category!.name, color: expense.category!.color)
//                                    
//                                    if expense.recurrence != .none {
//                                        Image(systemName: "repeat")
//                                            .frame(width: 6, height: 6)
//                                            .foregroundColor(.secondary)
//                                            .padding(.leading, 6)
//                                        
//                                        Text(expense.recurrence!.rawValue)
//                                            .font(.footnote)
//                                            .foregroundColor(.secondary)
//                                            .padding(.leading, 4)
//                                    }
//                                    
//                                    Spacer()
//                                    Text(formatDate(expense.date, format: "HH:mm"))
//                                        .font(.body)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                            .padding(.bottom, 12)
//                        }
//                    }
//                }
//            }
//            .environment(\.layoutDirection, .leftToRight)
//            .padding(.horizontal, 16)
//        }
//    }
//}
//
//struct ExpensesList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesList(expenses: [])
//    }
//}
//
//extension Double {
//    func roundTo(_ places: Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / divisor
//    }
//}
