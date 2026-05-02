# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | ContactVault |
| **Git URL** | git@github.com:asunnyboy861/ContactVault.git |
| **Repo URL** | https://github.com/asunnyboy861/ContactVault |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from /docs folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/ContactVault/ | ✅ Active |
| Support | https://asunnyboy861.github.io/ContactVault/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/ContactVault/privacy.html | ✅ Active |

**Note**: Terms of Use not required for paid download apps.

## Repository Structure

### Main App Repository
```
ContactVault/
├── ContactVault/                   # iOS App Source Code
│   ├── ContactVault.xcodeproj/     # Xcode Project
│   ├── ContactVault/               # Swift Source Files
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── ViewModels/
│   │   └── Utilities/
│   └── docs/                       # Policy Pages for GitHub Pages
│       ├── index.html              # Landing Page
│       ├── support.html            # Support Page
│       └── privacy.html            # Privacy Policy
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Pages deployment
├── us.md                           # English Development Guide
├── keytext.md                      # App Store Metadata
├── capabilities.md                 # Capabilities Configuration
├── icon.md                         # App Icon Details
├── price.md                        # Pricing Configuration
└── nowgit.md                       # This File
```

## App Store Connect Metadata

| Section | Character Count | Limit | Status |
|---------|----------------|-------|--------|
| Promotional Text | 120 | 170 | ✅ |
| Description | 1919 | 4000 | ✅ |
| Keywords | 93 | 100 | ✅ |

## Pricing

- **Model**: Paid Download
- **Price**: $2.99 (One-time purchase)
- **IAP**: Not required
- **Subscription**: None

## Testing

- ✅ iPhone Xs Max (iOS 18.4)
- ✅ iPad Pro 13-inch (M4) (iOS 18.4)
