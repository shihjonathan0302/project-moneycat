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
    @State private var selectedCategory: Category?
    
    func handleCreate() {
        guard let category = selectedCategory else { return }
        
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
                    AmountTextField(amount: $amount)
                    
                    CategoryPicker(selectedCategory: $selectedCategory)
                    
                    RecurrencePicker(recurrence: $recurrence)
                    
                    DatePickerRow(date: $date, dateRange: dateClosingRange)
                    
                    NoteTextField(note: $note)
                }
                .frame(maxWidth: .infinity)
                .scrollDisabled(true)
                .frame(height: 300)
                
                SubmitButton(action: handleCreate)
                
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

struct AmountTextField: View {
    @Binding var amount: String
    
    var body: some View {
        HStack {
            Text("Amount")
            Spacer()
            TextField("Amount", text: $amount)
                .multilineTextAlignment(.trailing)
                .submitLabel(.done)
                .keyboardType(.numberPad)
        }
    }
}

struct CategoryPicker: View {
    @Binding var selectedCategory: Category?
    
    var body: some View {
        HStack {
            Text("Categories")
            Spacer()
            Picker(selection: $selectedCategory, label: Text("")) {
                Text("Groceries").tag(Category.groceries)
                Text("Bills").tag(Category.bills)
                Text("Subscriptions").tag(Category.subscriptions)
                Text("Gas").tag(Category.gas)
            }
        }
    }
}

struct RecurrencePicker: View {
    @Binding var recurrence: Recurrence
    
    var body: some View {
        HStack {
            Text("Recurrence")
            Spacer()
            Picker(selection: $recurrence, label: Text("")) {
                Text("None").tag(Recurrence.none)
                Text("Daily").tag(Recurrence.daily)
                Text("Weekly").tag(Recurrence.weekly)
                Text("Monthly").tag(Recurrence.monthly)
                Text("Yearly").tag(Recurrence.yearly)
            }
        }
    }
}

struct DatePickerRow: View {
    @Binding var date: Date
    let dateRange: ClosedRange<Date>
    
    var body: some View {
        HStack {
            Text("Date")
            Spacer()
            DatePicker(
                selection: $date,
                in: dateRange,
                displayedComponents: .date,
                label: { Text("") }
            )
        }
    }
}

struct NoteTextField: View {
    @Binding var note: String
    
    var body: some View {
        HStack {
            Text("Note")
            Spacer()
            TextField("Note", text: $note)
                .multilineTextAlignment(.trailing)
                .submitLabel(.done)
        }
    }
}

struct SubmitButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Submit Expense", systemImage: "plus")
                .labelStyle(.titleOnly)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(10)
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
            .environmentObject(ExpensesViewModel())
    }
}
