//
//  Add.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/19.
//

import SwiftUI
import UIKit
import RealmSwift

struct Add: View {
    @EnvironmentObject var viewModel: ExpensesViewModel
    
    @State private var amount = ""
    @State private var recurrence = Recurrence.none
    @State private var date = Date()
    @State private var note = ""
    @State private var category = Category.groceries
    
    func handleCreate() {
        viewModel.addExpense(
            amount: Double(amount) ?? 0.0,
            category: category,
            recurrence: recurrence.rawValue,
            date: date,
            note: note
        )
                
        amount = ""
        note = ""
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding:.year, value: -1, to: Date())!
        let max = Date()
        return min...max
    }
    
    let dateClosingRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let currentDate = Date()
        let futureDate = calendar.date(byAdding: .year, value: 1, to: currentDate)!
        return currentDate...futureDate
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", text: $amount)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Categories")
                        Spacer()
                        Picker(selection: $category, label: Text(""), content: {
                            Text("Groceries").tag(Category.groceries)
                            Text("Bills").tag(Category.bills)
                            Text("Subscriptions").tag(Category.subscriptions)
                            Text("Gas").tag(Category.gas)
                        })
                    }
                    
                    HStack {
                        Text("Recurrence")
                        Spacer()
                        Picker(selection: $recurrence, label: Text(""), content: {
                            Text("None").tag(Recurrence.none)
                            Text("Daily").tag(Recurrence.daily)
                            Text("Weekly").tag(Recurrence.weekly)
                            Text("Monthly").tag(Recurrence.monthly)
                            Text("Yearly").tag(Recurrence.yearly)
                        })
                    }
                    
                    HStack{
                        Text("Date")
                        Spacer()
                        DatePicker(
                            selection: $date,
                            in: dateClosingRange,
                            displayedComponents: .date,
                            label: { Text("") }
                        )
                    }
                    
                    HStack {
                        Text("Note")
                        Spacer()
                        TextField("Note", text: $note)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollDisabled(true)
                .frame(height: 300)
                
                Button(action: {
                    handleCreate()
                }) {
                    Label("Submit Expense", systemImage: "plus")
                        .labelStyle(.titleOnly)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
                    }
                }
            }
            .padding(.top, -10)
        }
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
            .environmentObject(ExpensesViewModel())
    }
}
