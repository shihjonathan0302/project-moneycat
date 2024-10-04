//
//  Reports.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/４.
//

import SwiftUI
import RealmSwift
import Charts

struct Reports: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showingAnalyze = false
    @State private var selectedExpense: Expense?

    var wantExpenses: [Expense] {
        return realmManager.expenses.filter { $0.needOrWant == "Want" }
    }

    var body: some View {
        NavigationView {
            VStack {s
                if wantExpenses.isEmpty {
                    Text("No 'Want' expenses to analyze")
                        .font(.title2)
                        .foregroundColor(.gray)
                } else {
                    List(wantExpenses) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.note)
                                    .font(.headline)
                                Text("Amount: \(String(format: "%.2f", expense.amount))")
                                Text("Category: \(expense.category?.name ?? "No Category")")
                                Text("Date: \(expense.date, formatter: DateFormatter.shortDate)")
                            }
                            Spacer()
                            Button(action: {
                                self.selectedExpense = expense
                                self.showingAnalyze = true
                            }) {
                                Text("Analyze")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                if let selectedExpense = selectedExpense {
                    // Show the chart
                    Chart {
                        ForEach(wantExpenses, id: \.self) { expense in
                            PointMark(
                                x: .value("Worse Coefficient", expense.worseCoefficient * 100), // Converting to percentage
                                y: .value("Better Coefficient", expense.betterCoefficient * 100) // Converting to percentage
                            )
                            .symbolSize(expense.amount) // Point size representing amount
                        }
                    }
                    .axisY(.leading) // Move Y axis to the left
                    .frame(height: 300)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Reports")
            .sheet(isPresented: $showingAnalyze) {
                if let expense = selectedExpense {
                    AnalyzeView(expenses: [expense])
                }
            }
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
