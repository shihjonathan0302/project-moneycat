//
//  AnalyzeView.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/9/25.
//

import SwiftUI

struct AnalyzeView: View {
    var expense: Expense
    
    @State private var question1: Int = 3
    @State private var question2: Int = 3
    @State private var question3: Int = 3
    @State private var question4: Int = 3
    @State private var question5: Int = 3
    @State private var question6: Int = 3

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
                        // 提交數據的操作
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // 取消的操作
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
