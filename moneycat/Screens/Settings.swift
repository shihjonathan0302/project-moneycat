//
//  Settings.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/5.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationView {
                List {
                    NavigationLink {
                        Categories()
                    } label: {
                        HStack {
                            Text ("Categories")
                        }
                    }
                    
                    Text("Languages")
                    
                    Text("Help")

                    Button(role: .destructive){
                    } label: {
                        Text("Erase Data")
                    }
                                                            
                }
                .navigationTitle("Settings")
                .padding(20)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings ()
    }
}
