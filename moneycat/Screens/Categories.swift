//
//  Categories.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI
import RealmSwift

class Category: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var colorHex: String = ""

    var color: Color {
        get {
            Color(hex: colorHex)
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String {
        let components = self.cgColor?.components
        let r = Float(components?[0] ?? 0)
        let g = Float(components?[1] ?? 0)
        let b = Float(components?[2] ?? 0)
        return String(format: "%02lX%02lX%02lX", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

struct Categories: View {
    @ObservedResults(Category.self) var categories
    @State private var invalidDataAlertShowing = false
    @State private var newCategoryName: String = ""
    @State private var newCategoryColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    func handleSubmit() {
        if newCategoryName.count > 0 {
            let newCategory = Category()
            newCategory.name = newCategoryName
            newCategory.colorHex = newCategoryColor.toHex()
            $categories.append(newCategory)
            newCategoryName = ""
        } else {
            invalidDataAlertShowing = true
        }
    }
    
    func handleDelete(indexSet: IndexSet) {
        for index in indexSet {
            $categories.remove(at: index)
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(categories) { category in
                    HStack {
                        Circle()
                            .frame(width: 12)
                            .foregroundColor(category.color)
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
        Categories()
            .environment(\.realmConfiguration, Realm.Configuration(inMemoryIdentifier: "Temporary"))
    }
}
