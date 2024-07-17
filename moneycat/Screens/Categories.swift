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
    @State private var newCategoryColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    func handleSubmit() {
        if newCategoryName.count > 0 {
            let newCategory = ExpenseCategory()
            newCategory.name = newCategoryName
            newCategory.color = newCategoryColor.description // Convert Color to String
            self.realmManager.submitCategory(newCategory)
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
                            .frame(width: 12)
                            .foregroundColor(Color(category.color)) // Convert String to Color
                        Text(category.name)
                    }
                }
                .onDelete(perform: handleDelete)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                ColorPicker("", selection: $newCategoryColor, supportsOpacity: false)
                    .labelsHidden()
                    .accessibilityLabel("")
                
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
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories().environmentObject(RealmManager())
    }
}
