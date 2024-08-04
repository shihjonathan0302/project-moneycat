//
//  Add.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI
import RealmSwift
import AVKit

enum NeedOrWant: String, CaseIterable, Identifiable {
    case need = "Need"
    case want = "Want"
    
    var id: String { self.rawValue }
}

struct Add: View {
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var selectedCategory: ExpenseCategory?
    @State private var amount = ""
    @State private var recurrence = Recurrence.none
    @State private var date = Date()
    @State private var note = ""
    @State private var needOrWant: NeedOrWant = .need
    
    func onAppear() {
        if !realmManager.categories.isEmpty {
            self.selectedCategory = realmManager.categories.first
        }
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let max = Date()
        return min...max
    }
    
    func handleCreate() {
        guard let amount = Double(self.amount), let selectedCategory = self.selectedCategory else {
            // Handle invalid input gracefully
            return
        }
        
        let newExpense = Expense()
        newExpense.amount = amount
        newExpense.category = selectedCategory
        newExpense.recurrence = self.recurrence.rawValue
        newExpense.date = self.date
        newExpense.note = self.note.isEmpty ? selectedCategory.name : self.note
        newExpense.needOrWant = self.needOrWant.rawValue
        
        self.realmManager.submitExpense(newExpense)
        self.amount = ""
        self.recurrence = Recurrence.none
        self.date = Date()
        self.note = ""
        self.needOrWant = .need
        hideKeyboard()
    }
    
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
                            .keyboardType(.decimalPad)
                    }
                    
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
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        DatePicker(
                            "Select Date",
                            selection: $date,
                            in: dateClosedRange,
                            displayedComponents: .date
                        )
                    }
                    
                    HStack {
                        Text("Note")
                        Spacer()
                        TextField("Note", text: $note)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                    
                    HStack {
                        Text("Category")
                        Spacer()
                        Picker(selection: $selectedCategory, label: Text("")) {
                            if !realmManager.categories.isEmpty {
                                ForEach(realmManager.categories) { category in
                                    Text(category.name).tag(Optional(category))
                                }
                            } else {
                                Text("Create a category first").tag(Optional(selectedCategory))
                            }
                        }
                    }
                    
                    HStack {
                        Text("Need or Want")
                        Spacer()
                        Picker(selection: $needOrWant, label: Text("")) {
                            Text("Need").tag(NeedOrWant.need)
                            Text("Want").tag(NeedOrWant.want)
                        }
                    }
                }
                .scrollDisabled(true)
                .frame(height: 325)
                
                Button(action: handleCreate) {
                    Label("Submit expense", systemImage: "plus")
                        .labelStyle(.titleOnly)
                        .padding(.horizontal, 44)
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
                    Button(action: hideKeyboard) {
                        Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
                    }
                }
            }
            .padding(.top, 16)
            .navigationTitle("Add")
        }
        .onAppear {
            onAppear()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // Helper function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add().environmentObject(RealmManager())
    }
}
