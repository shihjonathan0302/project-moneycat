import SwiftUI
import RealmSwift

// Define the Expense model
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

// View model to handle expenses
class ExpensesViewModel: ObservableObject {
    private var realm: Realm
    @Published var expenses: Results<Expense>

    init() {
        do {
            realm = try Realm()
            expenses = realm.objects(Expense.self)
        } catch {
            fatalError("Failed to open Realm: \(error)")
        }
    }

    var expenseAmounts: [Double] {
        expenses.map { $0.amount }
    }

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}

// Main view showing expenses
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
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Expenses")
        }
    }
}

// Placeholder for Add view (replace with actual implementation)
struct Adding: View {
    var body: some View {
        Text("Add View")
            .navigationTitle("Add Expense")
    }
}

// Simple bar chart view
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

// Preview provider with mock data
struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ExpensesViewModel() // Initialize with actual data for preview
        return ExpensesView()
            .environmentObject(viewModel)
    }
}
