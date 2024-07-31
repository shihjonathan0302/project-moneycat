import SwiftUI
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var realmManager: RealmManager

    var body: some View {
        TabView {
            Social()
                .tabItem {
                    Label("Social", systemImage: "person.bubble.fill")
                }
            Reports()
                .tabItem {
                    Label("Reports", systemImage: "chart.xyaxis.line")
                }
            Add()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
            Expenses(expenses: realmManager.expenses)
                .tabItem {
                    Label("Expenses", systemImage: "square.and.arrow.up")
                }
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let realmManager = RealmManager()
        ContentView()
            .environmentObject(realmManager)
    }
}
