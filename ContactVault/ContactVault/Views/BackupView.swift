import SwiftUI

struct BackupView: View {
    @State private var viewModel = BackupViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    contactCountSection
                    formatSection
                    encryptionSection
                    backupButton
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Backup")
            .task {
                await viewModel.requestContactAccess()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.successMessage)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "shield.checkered")
                .font(.system(size: 48))
                .foregroundStyle(.blue)
            Text("Secure Backup")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Your contacts never leave your device")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }
    
    private var contactCountSection: some View {
        GroupBox {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(.blue)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text("\(viewModel.contactCount)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Contacts Found")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    Task { await viewModel.loadContactCount() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
            }
        } label: {
            Text("Contacts")
        }
    }
    
    private var formatSection: some View {
        GroupBox {
            VStack(spacing: 12) {
                ForEach(ExportFormat.allCases) { format in
                    HStack {
                        Image(systemName: format == .vcf ? "vcard.fill" : "tablecells.fill")
                            .foregroundStyle(format == viewModel.selectedFormat ? .blue : .secondary)
                        VStack(alignment: .leading) {
                            Text(format.rawValue)
                                .fontWeight(format == viewModel.selectedFormat ? .semibold : .regular)
                            Text(format.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if format == viewModel.selectedFormat {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectedFormat = format
                    }
                }
            }
        } label: {
            Text("Export Format")
        }
    }
    
    private var encryptionSection: some View {
        GroupBox {
            VStack(spacing: 12) {
                Toggle("Encrypt Backup", isOn: $viewModel.isEncrypted)
                if viewModel.isEncrypted {
                    SecureField("Encryption Password", text: $viewModel.encryptionPassword)
                        .textFieldStyle(.roundedBorder)
                    if viewModel.encryptionPassword.count < 6 {
                        Text("Password must be at least 6 characters")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
        } label: {
            Text("Security")
        }
    }
    
    private var backupButton: some View {
        Button {
            Task { await viewModel.performBackup() }
        } label: {
            HStack {
                if viewModel.isBackingUp {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "arrow.down.doc.fill")
                }
                Text(viewModel.isBackingUp ? "Backing Up..." : "Backup Now")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isBackingUp || viewModel.contactCount == 0 || (viewModel.isEncrypted && viewModel.encryptionPassword.count < 6))
    }
}
