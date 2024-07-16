//
//  ContentView.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/3/25.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    var body: some View {
        TabView {
            Social()
                .tabItem {
                    Label("Social", systemImage: "person.bubble.fill")
                }
            Reports()
                .tabItem {
                    Label("Reports", systemImage: "chart.xyaxis.line")
                }
            // Uncomment and provide appropriate implementation for Add view if needed
            // Add()
            //     .tabItem {
            //         Label("Add", systemImage: "plus.circle")
            //     }
            Expenses(expenses: sampleExpenses) // Provide the expenses argument
                .tabItem {
                    Label("Expenses", systemImage: "square.and.arrow.up")
                }
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RealmManager()) // Add this if RealmManager is needed
    }
}

// Sample data for testing
let sampleCategory = ExpenseCategory(value: ["name": "Groceries", "color": "blue"])
let sampleExpenses: [Expense] = [
    Expense(value: ["amount": 10.0, "category": sampleCategory, "recurrence": "None", "date": Date(), "note": "Milk"]),
    Expense(value: ["amount": 20.0, "category": sampleCategory, "recurrence": "None", "date": Date(), "note": "Bread"])
]
