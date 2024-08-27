//
//  Settings.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Categories()
                } label: {
                    HStack {
                        Text("Categories")
                    }
                }

                Text("Languages")

                Text("Help")

                Button(role: .destructive) {
                    showAlert = true
                } label: {
                    Text("Erase Data")
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Erase Data"),
                        message: Text("Are you sure you want to remove all the data?"),
                        primaryButton: .destructive(Text("Erase")) {
                            realmManager.eraseData() // Correctly call eraseData method here
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Settings")
            .padding(20)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let realmManager = RealmManager()
        Settings()
            .environmentObject(realmManager)
    }
}
