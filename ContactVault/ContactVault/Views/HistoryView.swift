import SwiftUI

struct HistoryView: View {
    @State private var viewModel = RestoreViewModel()
    @State private var records: [BackupRecord] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if records.isEmpty {
                    emptyState
                } else {
                    historyList
                }
            }
            .navigationTitle("History")
            .onAppear {
                records = viewModel.getBackupRecords()
            }
        }
    }
    
    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Backup History", systemImage: "clock.arrow.circlepath")
        } description: {
            Text("Your backup history will appear here after your first backup.")
        }
    }
    
    private var historyList: some View {
        List {
            ForEach(records) { record in
                HistoryRowView(record: record)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteRecord(records[index])
                }
                records = viewModel.getBackupRecords()
            }
        }
    }
}

struct HistoryRowView: View {
    let record: BackupRecord
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: record.format == "VCF" ? "vcard.fill" : "tablecells.fill")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(record.format)
                        .fontWeight(.medium)
                    if record.isEncrypted {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
                Text("\(record.contactCount) contacts")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(record.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(record.formattedSize)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
