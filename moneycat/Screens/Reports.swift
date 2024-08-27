//
//  Reports.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/4.
//

import SwiftUI
import RealmSwift
import Charts

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

    @State private var kanoScores: [(String, Double)] = []

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

                // Display the Kano scores as a bar chart if available
                if !kanoScores.isEmpty {
                    Text("Kano Model Analysis")
                        .font(.headline)
                        .padding(.top)

                    Chart(kanoScores, id: \.0) { score in
                        BarMark(
                            x: .value("Requirement", score.0),
                            y: .value("Score", score.1)
                        )
                    }
                    .frame(height: 200)
                    .padding()
                }
            }
            .navigationTitle("Reports")
            .sheet(isPresented: $showingQuestionnaire) {
                if let selectedExpense = selectedExpense {
                    QuestionnaireView(expense: selectedExpense, question1: $question1, question2: $question2, question3: $question3, question4: $question4, question5: $question5, question6: $question6, onSubmit: calculateKanoModelScores)
                }
            }
        }
    }

    private func calculateKanoModelScores() {
        // Calculate Basic, Attractive, Performance, Indifferent Scores
        let basicScore = Double(question1 + question2) / 2
        let attractiveScore = Double(question3 + question4) / 2
        let performanceScore = Double(question5)
        let indifferentScore = Double(question6)

        // Calculate Better-Worse Coefficients
        let betterCoefficient = (performanceScore + attractiveScore) / (performanceScore + attractiveScore + basicScore + indifferentScore)
        let worseCoefficient = (-1) * (performanceScore + basicScore) / (performanceScore + attractiveScore + basicScore + indifferentScore)

        // Store the scores for display
        self.kanoScores = [
            ("Basic", basicScore),
            ("Attractive", attractiveScore),
            ("Performance", performanceScore),
            ("Indifferent", indifferentScore),
            ("Better Coefficient", betterCoefficient),
            ("Worse Coefficient", worseCoefficient)
        ]
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

    var onSubmit: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本需求")) {
                    QuestionView(question: "你覺得這個包包對你的生活有實際的幫助嗎？", rating: $question1)
                    QuestionView(question: "這個包包是否滿足了你日常使用的需求？", rating: $question2)
                }
                Section(header: Text("魅力需求")) {
                    QuestionView(question: "你覺得買這個包包讓你感到開心嗎？", rating: $question3)
                    QuestionView(question: "如果沒有買這個包包，你會感到遺憾嗎？", rating: $question4)
                }
                Section(header: Text("期望需求")) {
                    QuestionView(question: "你覺得這個包包的價格是否合理？", rating: $question5)
                }
                Section(header: Text("無差異需求")) {
                    QuestionView(question: "你有考慮過其他品牌、款式或店家的這類產品嗎？", rating: $question6)
                }
            }
            .navigationTitle("Expense Analysis")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        onSubmit()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // Dismiss the sheet
                    }
                }
            }
        }
    }
}

struct QuestionView: View {
    var question: String
    @Binding var rating: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
            Picker("Rating", selection: $rating) {
                ForEach(1..<6) { score in
                    Text("\(score)").tag(score)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
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
