import Foundation
import Observation

@MainActor
@Observable
final class RestoreViewModel {
    var isRestoring = false
    var showError = false
    var errorMessage = ""
    var showSuccess = false
    var successMessage = ""
    var selectedRecord: BackupRecord?
    var decryptionPassword = ""
    var showPasswordPrompt = false
    
    private let exportService = ExportService.shared
    
    func getBackupRecords() -> [BackupRecord] {
        return exportService.getBackupRecords()
    }
    
    func deleteRecord(_ record: BackupRecord) {
        try? exportService.deleteBackupRecord(record)
    }
    
    func getFileURL(for record: BackupRecord) -> URL {
        return exportService.getBackupFileURL(for: record)
    }
}
