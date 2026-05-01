# ContactVault - iOS Development Guide

## Executive Summary

ContactVault is a privacy-first iOS contacts backup and export application that guarantees 100% local data processing with zero data collection. Unlike competitors that upload contacts to servers or charge expensive subscriptions, ContactVault offers a one-time purchase of $2.99 with AES-256 encrypted backups, strict RFC 6350 compliant VCF export, and multi-account support (iCloud/Exchange/Gmail/Local).

**Target Audience**: Privacy-conscious users, iOS update victims who lost contacts, device switchers, elderly users needing simple interfaces, and business professionals requiring reliable exports.

**Key Differentiators**:
- 100% local processing, zero data collection, zero server uploads
- One-time purchase $2.99 (no subscription fatigue)
- AES-256 encrypted backup files with Face ID/Touch ID protection
- Strict RFC 6350 compliant VCF generation (no data loss on restore)
- Multi-account support: iCloud, Exchange, Gmail, Local contacts
- Smart backup reminders with customizable intervals
- Extreme simplicity: 3-step backup flow

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| MCBackup | 4.7 stars, 2.3K ratings, one-tap backup, VCF/CSV | Subscription model, privacy unclear | No subscription, 100% local, AES-256 encryption |
| My Contacts Backup | Simple, email-based backup, 10K ratings | VCF format errors (comma escaping), data loss on restore, 500 contact cap | RFC 6350 compliant VCF, no data loss, no contact cap |
| Contacts Backup - Easy Export | 4.5 stars, 61 ratings, VCF/CSV | In-app purchases, privacy concerns | One-time price, zero data collection |
| Contacts Backup + Transfer | Free tier, cloud backup | Uploads to servers, privacy issues | 100% local, no server uploads |
| Contact.s Back Up | Simple interface | $4.99/week to $49.99/year subscription | $2.99 one-time, no recurring charges |

## Apple Design Guidelines Compliance

- **Contacts Framework**: Uses CNContactStore with proper authorization flow per Apple guidelines
- **Privacy**: No data leaves the device; Privacy Nutrition Label shows zero data collection
- **LocalAuthentication**: Face ID/Touch ID implemented with NSFaceIDUsageDescription in Info.plist
- **UserNotifications**: Backup reminders use UNUserNotificationCenter with proper authorization
- **ShareLink**: Uses native SwiftUI ShareLink for AirDrop/Mail/Message sharing
- **FileManager**: App Sandbox compliant local storage in Documents directory
- **Human Interface Guidelines**: Minimal UI with clear navigation, large touch targets, accessibility support

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (activity indicator for export)
- **Data**: FileManager for local backup storage, UserDefaults for settings
- **Security**: CryptoKit for AES-256 encryption, LocalAuthentication for biometric lock
- **Contacts**: Apple Contacts framework (CNContactStore)
- **Notifications**: UserNotifications framework for backup reminders
- **Sharing**: SwiftUI ShareLink for native sharing
- **File Types**: UniformTypeIdentifiers for VCF/CSV file handling

## Module Structure

```
ContactVault/
├── ContactVaultApp.swift
├── Models/
│   ├── BackupRecord.swift
│   └── ExportFormat.swift
├── ViewModels/
│   ├── BackupViewModel.swift
│   ├── RestoreViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── MainTabView.swift
│   ├── BackupView.swift
│   ├── RestoreView.swift
│   ├── HistoryView.swift
│   ├── SettingsView.swift
│   └── ContactSupportView.swift
├── Services/
│   ├── ContactService.swift
│   ├── ExportService.swift
│   ├── CryptoService.swift
│   └── NotificationService.swift
└── Utilities/
    ├── VCFGenerator.swift
    ├── CSVGenerator.swift
    └── Constants.swift
```

## Implementation Flow

1. Create data models (BackupRecord, ExportFormat)
2. Implement ContactService (CNContactStore access, fetch all contacts)
3. Implement VCFGenerator (strict RFC 6350 compliant)
4. Implement CSVGenerator (proper escaping)
5. Implement ExportService (combines generators, saves to Documents)
6. Implement CryptoService (AES-256 encrypt/decrypt with CryptoKit)
7. Implement NotificationService (backup reminders)
8. Create BackupViewModel (orchestrates backup flow)
9. Create RestoreViewModel (handles restore from VCF/CSV)
10. Create SettingsViewModel (app settings, reminder config)
11. Build MainTabView (tab-based navigation)
12. Build BackupView (main backup UI with progress)
13. Build RestoreView (restore from file)
14. Build HistoryView (backup history list)
15. Build SettingsView (settings, policy links, support)
16. Build ContactSupportView (feedback form)
17. Integrate all views in ContactVaultApp
18. Add Face ID/Touch ID protection for encrypted backups
19. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: #007AFF (iOS Blue)
  - Accent: #34C759 (Green for success states)
  - Warning: #FF9500 (Orange for alerts)
  - Error: #FF3B30 (Red for errors)
  - Background: System backgrounds (adaptive light/dark)
- **Typography**: SF Pro, system font sizes per Apple HIG
- **Layout**: 
  - Tab-based navigation: Backup, Restore, History, Settings
  - Max content width 720pt for iPad
  - Large touch targets (44pt minimum)
  - Clear visual hierarchy with sections
- **Animations**: Subtle transitions, progress indicators during backup/restore
- **Iconography**: SF Symbols throughout for consistency

## Code Generation Rules

- Single responsibility: one feature per module
- MVVM pattern: View + ViewModel separation
- No third-party dependencies: Apple native frameworks only
- All code in Swift/SwiftUI
- No comments in code unless explicitly requested
- Proper error handling with do-catch and async/await
- Accessibility: labels, traits, dynamic type support

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.ContactVault
2. Verify Deployment Target: iOS 17.0
3. Add NSContactsUsageDescription to Info.plist
4. Add NSFaceIDUsageDescription to Info.plist
5. Configure app icon (1024x1024)
6. Build and test on iPhone simulator
7. Build and test on iPad simulator
8. Push to GitHub repository
9. Deploy policy pages to GitHub Pages
10. Prepare App Store Connect metadata
