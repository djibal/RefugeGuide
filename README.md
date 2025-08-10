# I'm taking a break from now / 10 August 2025:
----------------------------------------------------------------------
RefugeGuide app is built and running successfully, and all features have been tested and are working well.
Unfortunately, the UK government does not have an API for asylum seekers and those granted visas.
Given that this app focuses on refugees and tracks their progress, without an API is truly unprofessional, as I have to ask users to manually add all their details.

---

# UK RefugeGuide App 🇬🇧

**RefugeGuide** is a secure, multilingual iOS app designed to support asylum seekers and refugees navigating the UK asylum process. Built with SwiftUI and Firebase, it offers trusted guidance, document tools, live assistance, and access to local support resources — all in one accessible app.

---

## ✨ Core Features

* 🧓‍♂️ **Application Tracker**
  Track your asylum application's progress: screening, interviews, decisions, and appeals.

* 📂 **Document Upload & Storage**
  Upload and manage asylum-related documents (ARC, BRP, Home Office letters) securely in the cloud.

* 🗂️ **Document Categories + Filtering**
  Tag your uploads by type (ARC, BRP, etc.) and filter them easily.

* 🔄 **Pull-to-Refresh + File Deletion**
  View, refresh, and delete your uploaded documents with ease.

* 🌍 **Multilingual Interface**
  App supports English, Arabic, Farsi, French, Pashto, Kurdish, Ukrainian, and Urdu.

* 📍 **Resource Finder (Map)**
  Locate NHS clinics, legal help, food banks, housing services near you.

* 🌐 **Local Services Directory**
  Discover nearby refugee-friendly services (legal aid, clinics, food banks) with map-based UI.

* 🎥 **Video Consultations (Setup Complete)**
  Schedule and simulate remote sessions with advisors using Agora SDK.

* 🧠 **AI Assistant (Beta)**
  Chat with a multilingual AI assistant via OpenAI-powered Firebase Cloud Function.

* 🛂 **eVisa Viewer & Verification**
  Simulate immigration status (BRP/eVisa) and store travel permission info.
  
  
## 🔐 Firebase Auth login via EVisaLoginView
* 🔄 Real-time data fetch from Firestore: /evisa/{uid}
* 📦 EVisaData struct for clean data modeling
* 📊 Dynamic display of immigration status items
* 📤 Share Code section with copy-to-clipboard and alert
* 🌍 Portal redirect only after login
* 🚪 Logout button integrated in navigation bar
* 🌐 Language localization support for titles and status
* ✅ All enhancements are wrapped in the existing EVisaView UI structure

## 🔐 **Private by Design**
  Your data is encrypted, anonymized, and GDPR-compliant.
  
---

## 🧠 Additional features implemented

* [ ] AI Document Processing (OCR + NLP via ML Kit or GPT)
* [ ] AR Navigation to Support Services (ARKit + CoreLocation)
* [ ] Biometric Login (Face ID / Touch ID)
* [ ] Offline Forms & Emergency Info
* [ ] Human Support Escalation (Live Help)
* [ ] Simulated Government API Integration

---

## 🎨 UI Design System (July 2025)
To unify the app’s appearance, RefugeGuide now uses a shared design system defined in DesignSystem.swift:

* AppColors.primary        // Deep UK blue
* AppColors.accent         // UK orange
* AppColors.background     // Light neutral background
* AppColors.cardBackground // Clean white surface

- These values are applied consistently across all views including:

##  🎨 Buttons (PrimaryButtonStyle.swift)
 🎨 Buttons (PrimaryButtonStyle.swift)
 
- Cards, scroll backgrounds, and chat input areas
- Multilingual flows and profile sections
- This system improves maintainability, brand consistency, and prepares the app for theming and dark mode support in future updates.

---

## 🛠️ Tech Stack

* **SwiftUI** (iOS 16+)
* **Firebase** (Auth, Firestore, Storage, Functions)
* **OpenAI SDK** (via Firebase Functions)
* **MapKit** (local resource discovery)
* **Agora SDK** (video calls)
* **CocoaPods** & **Swift Package Manager**
* **AlertToast** & **Swift Package Manager**
* **Node.js 18/20** for Firebase backend
* **Multilingual `.strings` Localization**

---

## 📁 Project Structure | 20 Folders + 118 Swift file Created

RefugeGuide/
├── Views/
│   ├── OnboardingViews/
│   ├── DashboardViews/
│   ├── DocumentViews/
│   ├── ConsultationViews/
│   ├── Previews/
│   ├── ProfileViews/
│   ├── TabViews/
│   ├── Shared/
│   ├── Community/
│   ├── CommunityViews/
│   ├── LocalServices/
│   ├── Help/
│   ├── SettingsViews/
│   ├── Components/
├── Models/
├── Services/
├── Utilities/
├── Resources/Localizable.xcstrings/
├── ViewModels/
├── Resources/ (e.g. Localizable.xcstrings)
├── Firebase/ (functions/chatWithGPT)

## 🔧Jun/July 2025 Updates

- ✅ Added 40+ SwiftUI files: onboarding screens, profile logic, status mapping
- 🌍 Introduced `RefugeeUserType`, `RefugeeStatus`, and `UserType` conversion helpers
- 🧠 HelpResources module with `HelpResource.swift`, custom row view, and safety plan sheet
- 🗂 Files organized into folders: `Views/OnboardingViews`, `Views/Profile`, `Views/ConsultationViews`, etc.
- 🗨️ Added ConsultationScheduleView, improved state handling and navigation

## ✨ Enhanced Launch Experience

- Added a sophisticated text animation for RefugeGuide's splash screen:


## 🔐 Security

Sensitive keys like `GoogleService-Info.plist` & `API and SecureConfig file` are excluded from the repo and managed via `.gitignore`.

---

## 📦 Backend Setup

 `firebase init functions` in `refugeguide2025/`

* Installed OpenAI SDK + Firebase Admin SDK
* Created `chatWithGPT` function using Node.js 18 (deployed via Node.js 20)
* Created 'getAsylumCaseStatus' function (deployed via Node.js 20)
* Created 'generateAgoraToken' function  (deployed via Node.js 20)
* Created 'getConsultations' function  (deployed via Node.js 20)
* Secured All APIs key via environment config/ Finally, everything was configured in cloud functions
* ✅ Deployed & tested via Firebase CLI

---

## 👥 Credits

Developed with input from UK refugee organizations and trauma-informed design principles.

---
* Feel free to clone this repository, explore the code, and contribute improvements or translations.
* Whether you're a developer or freelancer, designer, or advocate — your input is welcome.

🔗 git clone https://github.com/djibal/RefugeGuide.git

---

## 📄 License

MIT License – use freely, contribute openly, protect privacy.
