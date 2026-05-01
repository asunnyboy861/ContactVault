import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    
    private let supportURL = "https://asunnyboy861.github.io/ContactVault/support.html"
    private let privacyURL = "https://asunnyboy861.github.io/ContactVault/privacy.html"
    
    var body: some View {
        NavigationStack {
            Form {
                reminderSection
                aboutSection
                legalSection
            }
            .navigationTitle("Settings")
        }
    }
    
    private var reminderSection: some View {
        Section("Backup Reminders") {
            Toggle("Enable Reminders", isOn: $viewModel.reminderEnabled)
            
            if viewModel.reminderEnabled {
                Picker("Reminder Frequency", selection: $viewModel.reminderInterval) {
                    ForEach(Constants.ReminderInterval.allCases) { interval in
                        Text(interval.displayName).tag(interval)
                    }
                }
            }
        }
    }
    
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Privacy")
                Spacer()
                Text("100% Local")
                    .foregroundStyle(.green)
                    .fontWeight(.medium)
            }
            
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope.fill")
            }
        }
    }
    
    private var legalSection: some View {
        Section("Legal") {
            Link(destination: URL(string: supportURL)!) {
                Label("Support Page", systemImage: "questionmark.circle.fill")
            }
            Link(destination: URL(string: privacyURL)!) {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }
        }
    }
}
