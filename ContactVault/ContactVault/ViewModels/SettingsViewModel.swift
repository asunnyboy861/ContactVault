import Foundation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    var reminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(reminderEnabled, forKey: Constants.reminderEnabledKey)
            if reminderEnabled {
                scheduleReminder()
            } else {
                NotificationService.shared.cancelReminder()
            }
        }
    }
    
    var reminderInterval: Constants.ReminderInterval {
        didSet {
            UserDefaults.standard.set(reminderInterval.rawValue, forKey: Constants.reminderIntervalKey)
            if reminderEnabled {
                scheduleReminder()
            }
        }
    }
    
    init() {
        self.reminderEnabled = UserDefaults.standard.bool(forKey: Constants.reminderEnabledKey)
        let savedInterval = UserDefaults.standard.double(forKey: Constants.reminderIntervalKey)
        if savedInterval > 0, let interval = Constants.ReminderInterval(rawValue: savedInterval) {
            self.reminderInterval = interval
        } else {
            self.reminderInterval = .weekly
        }
    }
    
    private func scheduleReminder() {
        Task {
            let authorized = await NotificationService.shared.requestAuthorization()
            if authorized {
                NotificationService.shared.scheduleReminder(interval: reminderInterval.rawValue)
            }
        }
    }
}
