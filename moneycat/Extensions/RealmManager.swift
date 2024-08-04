//
//  RealmManager.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/8/4.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published var expenses: [Expense] = []
    @Published var categories: [ExpenseCategory] = []
    
    init() {
        openRealm()
        loadExpenses()
        loadCategories()
        addDefaultCategoriesIfNeeded()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Perform any necessary migrations here
                }
            })
            
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            print("Realm opened successfully")
        } catch {
            print("Error opening Realm", error)
        }
    }

    func loadExpenses() {
        if let localRealm = localRealm {
            let allExpenses = localRealm.objects(Expense.self).sorted(byKeyPath: "date")
            expenses = Array(allExpenses)
            print("Loaded \(expenses.count) expenses")
        }
    }
    
    func submitExpense(_ expense: Expense) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(expense)
                    loadExpenses()
                    print("Expense submitted to Realm!", expense)
                }
            } catch {
                print("Error submitting expense to Realm: \(error)")
            }
        }
    }
    
    func loadCategories() {
        if let localRealm = localRealm {
            let allCategories = localRealm.objects(ExpenseCategory.self)
            categories = Array(allCategories)
            print("Loaded \(categories.count) categories")
        }
    }
    
    func submitCategory(_ category: ExpenseCategory) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(category)
                    loadCategories()
                    print("Category submitted to Realm!", category)
                }
            } catch {
                print("Error submitting category to Realm: \(error)")
            }
        }
    }
    
    func deleteCategory(category: ExpenseCategory) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.delete(category)
                    loadCategories()
                    print("Category deleted from Realm!", category)
                }
            } catch {
                print("Error deleting category to Realm: \(error)")
            }
        }
    }
    
    func addDefaultCategoriesIfNeeded(force: Bool = false) {
        if categories.isEmpty || force {
            print("No categories found, adding default categories")
            let defaultCategories = [
                ExpenseCategory(value: ["name": "Food", "color": "#FF6347"]),
                ExpenseCategory(value: ["name": "Rent", "color": "#4682B4"]),
                ExpenseCategory(value: ["name": "Utilities", "color": "#9ACD32"]),
                ExpenseCategory(value: ["name": "Transportation", "color": "#FFD700"])
            ]
            for category in defaultCategories {
                submitCategory(category)
            }
        } else {
            print("Categories already exist, not adding defaults")
        }
    }
}
