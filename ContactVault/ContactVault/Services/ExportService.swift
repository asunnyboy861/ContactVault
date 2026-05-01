import Contacts
import Foundation
import UniformTypeIdentifiers

final class ExportService {
    static let shared = ExportService()
    
    private init() {}
    
    private var backupsDirectory: URL {
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let backupDir = documentsDir.appendingPathComponent(Constants.backupDirectoryName)
        try? FileManager.default.createDirectory(at: backupDir, withIntermediateDirectories: true)
        return backupDir
    }
    
    func exportContacts(_ contacts: [CNContact], format: ExportFormat, encrypt: Bool = false, password: String? = nil) throws -> BackupRecord {
        let data: Data?
        switch format {
        case .vcf:
            data = VCFGenerator.generate(contacts: contacts)
        case .csv:
            data = CSVGenerator.generate(contacts: contacts)
        }
        
        guard let exportData = data else {
            throw ExportError.generationFailed
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let timestamp = dateFormatter.string(from: Date())
        let fileName = "\(Constants.backupFilePrefix)\(timestamp).\(format.fileExtension)"
        let fileURL = backupsDirectory.appendingPathComponent(fileName)
        
        let finalData: Data
        let isEncrypted: Bool
        
        if encrypt, let password = password, !password.isEmpty {
            let key = CryptoService.deriveKey(from: password)
            finalData = try CryptoService.encrypt(data: exportData, key: key)
            isEncrypted = true
        } else {
            finalData = exportData
            isEncrypted = false
        }
        
        try finalData.write(to: fileURL)
        
        let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
        let fileSize = (attributes[.size] as? Int64) ?? 0
        
        let record = BackupRecord(
            contactCount: contacts.count,
            format: format.rawValue,
            fileName: fileName,
            fileSize: fileSize,
            isEncrypted: isEncrypted
        )
        
        saveBackupRecord(record)
        return record
    }
    
    func getBackupRecords() -> [BackupRecord] {
        guard let data = UserDefaults.standard.data(forKey: Constants.backupHistoryKey) else {
            return []
        }
        return (try? JSONDecoder().decode([BackupRecord].self, from: data)) ?? []
    }
    
    func deleteBackupRecord(_ record: BackupRecord) throws {
        let fileURL = backupsDirectory.appendingPathComponent(record.fileName)
        try? FileManager.default.removeItem(at: fileURL)
        
        var records = getBackupRecords()
        records.removeAll { $0.id == record.id }
        saveRecords(records)
    }
    
    func getBackupFileURL(for record: BackupRecord) -> URL {
        return backupsDirectory.appendingPathComponent(record.fileName)
    }
    
    private func saveBackupRecord(_ record: BackupRecord) {
        var records = getBackupRecords()
        records.insert(record, at: 0)
        if records.count > 50 {
            records = Array(records.prefix(50))
        }
        saveRecords(records)
    }
    
    private func saveRecords(_ records: [BackupRecord]) {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: Constants.backupHistoryKey)
        }
    }
    
    enum ExportError: LocalizedError {
        case generationFailed
        case noContacts
        
        var errorDescription: String? {
            switch self {
            case .generationFailed: return "Failed to generate backup file"
            case .noContacts: return "No contacts to backup"
            }
        }
    }
}
