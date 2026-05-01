import Foundation

enum Constants {
    static let backupDirectoryName = "Backups"
    static let backupFilePrefix = "ContactVault_"
    static let backupHistoryKey = "backupHistory"
    static let reminderEnabledKey = "reminderEnabled"
    static let reminderIntervalKey = "reminderInterval"
    static let defaultReminderInterval: Double = 7 * 24 * 60 * 60
    
    enum ReminderInterval: Double, CaseIterable, Identifiable {
        case daily = 86400
        case weekly = 604800
        case biweekly = 1209600
        case monthly = 2592000
        
        var id: Double { rawValue }
        
        var displayName: String {
            switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .biweekly: return "Every 2 Weeks"
            case .monthly: return "Monthly"
            }
        }
    }
}
