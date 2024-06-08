//
//  ContentView.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
            Social ()
                .tabItem {
                    Label("Social", systemImage:"person.bubble.fill")
                }
            Reports ()
                .tabItem {
                    Label("Reports", systemImage:"chart.xyaxis.line")
                }
            Expenses ()
                .tabItem {
                    Label ("Expenses", systemImage: "square.and.arrow.up")
                }
            Settings ()
                .tabItem {
                    Label ("Settings", systemImage: "gearshape.fill")
                }
         }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

