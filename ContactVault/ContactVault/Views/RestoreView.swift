import SwiftUI

struct RestoreView: View {
    @State private var viewModel = RestoreViewModel()
    @State private var records: [BackupRecord] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if records.isEmpty {
                    emptyState
                } else {
                    backupList
                }
            }
            .navigationTitle("Restore")
            .onAppear {
                records = viewModel.getBackupRecords()
            }
        }
    }
    
    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Backups", systemImage: "arrow.uturn.backward")
        } description: {
            Text("Create a backup first to restore from it later.")
        }
    }
    
    private var backupList: some View {
        List {
            ForEach(records) { record in
                RestoreRowView(record: record, fileURL: viewModel.getFileURL(for: record))
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let record = records[index]
                    viewModel.deleteRecord(record)
                }
                records = viewModel.getBackupRecords()
            }
        }
    }
}

struct RestoreRowView: View {
    let record: BackupRecord
    let fileURL: URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: record.format == "VCF" ? "vcard.fill" : "tablecells.fill")
                    .foregroundStyle(.blue)
                Text(record.fileName)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                if record.isEncrypted {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                }
            }
            
            HStack(spacing: 16) {
                Label("\(record.contactCount) contacts", systemImage: "person.2")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Label(record.formattedSize, systemImage: "doc")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(record.formattedDate)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            ShareLink(item: fileURL, subject: Text("ContactVault Backup")) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .tint(.blue)
        }
    }
}
