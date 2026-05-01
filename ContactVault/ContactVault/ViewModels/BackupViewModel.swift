import Contacts
import Foundation
import Observation

@MainActor
@Observable
final class BackupViewModel {
    var contactCount: Int = 0
    var isBackingUp = false
    var backupProgress: Double = 0
    var selectedFormat: ExportFormat = .vcf
    var isEncrypted = false
    var encryptionPassword = ""
    var showError = false
    var errorMessage = ""
    var showSuccess = false
    var successMessage = ""
    var hasContactAccess = false
    
    private let contactService = ContactService.shared
    private let exportService = ExportService.shared
    
    func requestContactAccess() async {
        hasContactAccess = await contactService.requestAccess()
        if hasContactAccess {
            await loadContactCount()
        } else {
            contactCount = 0
        }
    }
    
    func loadContactCount() async {
        do {
            contactCount = try await contactService.getContactCount()
        } catch {
            contactCount = 0
        }
    }
    
    func performBackup() async {
        guard contactCount > 0 else {
            errorMessage = "No contacts to backup"
            showError = true
            return
        }
        
        isBackingUp = true
        backupProgress = 0
        
        do {
            let contacts = try await contactService.fetchAllContacts()
            backupProgress = 0.3
            
            let password = isEncrypted ? encryptionPassword : nil
            let record = try exportService.exportContacts(contacts, format: selectedFormat, encrypt: isEncrypted, password: password)
            backupProgress = 1.0
            
            successMessage = "Backed up \(record.contactCount) contacts successfully!"
            showSuccess = true
            encryptionPassword = ""
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isBackingUp = false
    }
}
