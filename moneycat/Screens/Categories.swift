//
//  Categories.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI
import RealmSwift

struct Categories: View {
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var invalidDataAlertShowing = false
    @State private var newCategoryName: String = ""
    
    func handleSubmit() {
        if newCategoryName.count > 0 {
            let newCategory = ExpenseCategory()
            newCategory.name = newCategoryName
            newCategory.color = UIColor.random().toHexString()  // Assign a random color
            self.realmManager.submitCategory(newCategory)
            print("Submitted new category: \(newCategoryName)")
            newCategoryName = ""
        } else {
            invalidDataAlertShowing = true
        }
    }
    
    func handleDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            realmManager.deleteCategory(category: realmManager.categories[index])
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(realmManager.categories, id: \.id) { category in
                    HStack {
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(category.swiftUIColor)  // Convert String to Color
                        Text(category.name)
                    }
                }
                .onDelete(perform: handleDelete)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                ZStack(alignment: .trailing) {
                    TextField("New category", text: $newCategoryName)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit {
                            handleSubmit()
                        }
                    
                    if newCategoryName.count > 0 {
                        Button {
                            newCategoryName = ""
                        } label: {
                            Label("Clear input", systemImage: "xmark.circle.fill")
                                .labelStyle(.iconOnly)
                                .foregroundColor(.gray)
                                .padding(.trailing, 6)
                        }
                    }
                }
                
                Button {
                    handleSubmit()
                } label: {
                    Label("Submit", systemImage: "paperplane.fill")
                        .labelStyle(.iconOnly)
                        .padding(6)
                }
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
                .alert("Must provide a category name!", isPresented: $invalidDataAlertShowing) {
                    Button("OK", role: .cancel) {
                        invalidDataAlertShowing = false
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .navigationTitle("Categories")
        }
        .padding(.top, 16)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    hideKeyboard()
                } label: {
                    Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
                }
            }
        }
    }
    
    func randomColor() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        let realmManager = RealmManager()
        realmManager.addDefaultCategoriesIfNeeded(force: true)  // Force add default categories for preview
        print("Preview: Loaded \(realmManager.categories.count) categories")
        return Categories()
            .environmentObject(realmManager)
    }
}
