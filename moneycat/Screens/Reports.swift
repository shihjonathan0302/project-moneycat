//
//  Reports.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/4.
//

//
//  Reports.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/4.
//

import SwiftUI
import Charts
import RealmSwift

struct Reports: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showingAnalyze = false
    @State private var selectedExpense: Expense?

    var wantExpenses: [Expense] {
        return realmManager.expenses.filter { $0.needOrWant == "Want" }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Show the Kano Model chart
                Chart(wantExpenses) { expense in
                    PointMark(
                        x: .value("Worse", calculateWorseCoefficient(expense: expense)),  // Worse coefficient in percentage
                        y: .value("Better", calculateBetterCoefficient(expense: expense))  // Better coefficient in percentage
                    )
                    .foregroundStyle(by: .value("Category", expense.category?.name ?? "Other"))
                }
                .frame(height: 300)
                .padding()

                // List of 'Want' expenses
                List(wantExpenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.note)
                                .font(.headline)
                            Text("Amount: \(expense.amount, specifier: "%.2f")")
                            Text("Category: \(expense.category?.name ?? "No Category")")
                        }
                        Spacer()
                        Button("Analyze") {
                            selectedExpense = expense
                            showingAnalyze = true
                        }
                        .foregroundColor(.blue)
                    }
                }

                // Button at the bottom for going to AnalyzeView
                Button("Go to Analyze") {
                    if selectedExpense != nil {
                        showingAnalyze = true
                    } else {
                        print("Please select an expense to analyze")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .navigationTitle("Reports")
            .navigationDestination(isPresented: $showingAnalyze) {
                if let selectedExpense = selectedExpense {
                    AnalyzeView(expense: selectedExpense)
                }
            }
        }
    }

    // Example function to calculate Better coefficient
    func calculateBetterCoefficient(expense: Expense) -> Double {
        return Double.random(in: 0...1) * 100  // Convert to percentage
    }

    // Example function to calculate Worse coefficient
    func calculateWorseCoefficient(expense: Expense) -> Double {
        return Double.random(in: -1...0) * 100  // Convert to percentage
    }
}
