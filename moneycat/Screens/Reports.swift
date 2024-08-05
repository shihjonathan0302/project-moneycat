//
//  Reports.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/4.
//

import SwiftUI
import RealmSwift

struct Reports: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showingQuestionnaire = false
    @State private var selectedExpense: Expense?
    
    @State private var question1: Int = 3
    @State private var question2: Int = 3
    @State private var question3: Int = 3
    @State private var question4: Int = 3
    @State private var question5: Int = 3
    @State private var question6: Int = 3
    
    var wantExpenses: [Expense] {
        return realmManager.expenses.filter { $0.needOrWant == "Want" }
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
                                self.showingQuestionnaire = true
                            }) {
                                Text("Analyze")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Reports")
            .sheet(isPresented: $showingQuestionnaire) {
                if let selectedExpense = selectedExpense {
                    QuestionnaireView(expense: selectedExpense, question1: $question1, question2: $question2, question3: $question3, question4: $question4, question5: $question5, question6: $question6)
                }
            }
        }
    }
}

struct QuestionnaireView: View {
    var expense: Expense
    @Binding var question1: Int
    @Binding var question2: Int
    @Binding var question3: Int
    @Binding var question4: Int
    @Binding var question5: Int
    @Binding var question6: Int
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question 1")) {
                    Text("Do you think this item is practically helpful for your life?")
                    Picker("Rating", selection: $question1) {
                        ForEach(1..<6) { score in
                            Text("\(score)").tag(score)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Question 2")) {
                    Text("Does this item meet your daily needs?")
                    Picker("Rating", selection: $question2) {
                        ForEach(1..<6) { score in
                            Text("\(score)").tag(score)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Question 3")) {
                    Text("Did buying this item make you happy?")
                    Picker("Rating", selection: $question3) {
                        ForEach(1..<6) { score in
                            Text("\(score)").tag(score)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Question 4")) {
                    Text("Would you regret not buying this item?")
                    Picker("Rating", selection: $question4) {
                        ForEach(1..<6) { score in
                            Text("\(score)").tag(score)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Question 5")) {
                    Text("Do you think the price of this item is reasonable?")
                    Picker("Rating", selection: $question5) {
                        ForEach(1..<6) { score in
                            Text("\(score)").tag(score)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Question 6")) {
                    Text("Have you considered other brands, styles, or stores for this type of item?")
                    Picker("Rating", selection: $question6) {
                        ForEach(1..<6) { score in
                            Text("\(score)").tag(score)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Expense Analysis")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        // Handle submission logic here
                        // Save the ratings to the database or process them as needed
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // Handle cancel action
                    }
                }
            }
        }
    }
}

struct Reports_Previews: PreviewProvider {
    static var previews: some View {
        Reports().environmentObject(RealmManager())
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
