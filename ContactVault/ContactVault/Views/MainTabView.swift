import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            BackupView()
                .tabItem {
                    Label("Backup", systemImage: "arrow.down.doc.fill")
                }
            
            RestoreView()
                .tabItem {
                    Label("Restore", systemImage: "arrow.uturn.backward")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
