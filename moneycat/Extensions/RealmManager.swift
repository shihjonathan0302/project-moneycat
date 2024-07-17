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
        } catch {
            print("Error opening Realm", error)
        }
    }

    
    func loadExpenses() {
        if let localRealm = localRealm {
            let allExpenses = localRealm.objects(Expense.self).sorted(byKeyPath: "date")
            
            expenses = Array(allExpenses)
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
}
