import Foundation

struct BackupRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let contactCount: Int
    let format: String
    let fileName: String
    let fileSize: Int64
    let isEncrypted: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
    
    init(id: UUID = UUID(), date: Date = Date(), contactCount: Int, format: String, fileName: String, fileSize: Int64, isEncrypted: Bool = false) {
        self.id = id
        self.date = date
        self.contactCount = contactCount
        self.format = format
        self.fileName = fileName
        self.fileSize = fileSize
        self.isEncrypted = isEncrypted
    }
}
