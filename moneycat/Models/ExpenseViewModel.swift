//
//  Expense.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/5/23.
//

//import SwiftUI
//import RealmSwift
//
//// Define Category (assuming it's a simple enum, update as per your definition)
//enum Category: String, PersistableEnum {
//    case groceries, bills, subscriptions, gas
//}
//
//// Define Recurrence (assuming it's a simple enum, update as per your definition)
//enum Recurrence: String, PersistableEnum {
//    case none, daily, weekly, monthly, yearly
//}
//
//// Define MyAppExpense model
//class MyAppExpense: Object, Identifiable {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var amount: Double = 0.0
//    @Persisted var category: Category = .groceries
//    @Persisted var date: Date = Date()
//    @Persisted var note: String = ""
//    @Persisted var recurrence: Recurrence = .none
//}
//
//// View model to handle expenses
//class ExpensesViewModel: ObservableObject {
//    private var realm: Realm
//    @Published var expenses: Results<MyAppExpense>
//
//    init() {
//        do {
//            realm = try Realm()
//            expenses = realm.objects(MyAppExpense.self)
//        } catch {
//            fatalError("Failed to open Realm: \(error)")
//        }
//    }
//
//    var expenseAmounts: [Double] {
//        return expenses.map { $0.amount }
//    }
//
//    var totalExpenses: Double {
//        return expenses.reduce(0) { $0 + $1.amount }
//    }
//
//    func addExpense(amount: Double, category: Category, recurrence: String, date: Date, note: String) {
//        let expense = MyAppExpense(amount: amount, category: category, date: date, note: note, recurrence: Recurrence(rawValue: recurrence) ?? .none)
//
//        do {
//            try realm.write {
//                realm.add(expense)
//            }
//            // Trigger the @Published property to update views
//            expenses = realm.objects(MyAppExpense.self)
//        } catch {
//            print("Error adding expense: \(error)")
//        }
//    }
//}
