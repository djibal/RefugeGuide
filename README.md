# RefugeGuide 🇬🇧

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

* 🔐 **Private by Design**
  Your data is encrypted, anonymized, and GDPR-compliant.

---

## 🧠 Upcoming Features

* [ ] AI Document Processing (OCR + NLP via ML Kit or GPT)
* [ ] AR Navigation to Support Services (ARKit + CoreLocation)
* [ ] Biometric Login (Face ID / Touch ID)
* [ ] Offline Forms & Emergency Info
* [ ] Human Support Escalation (Live Help)
* [ ] Simulated Government API Integration

---

## 🛠️ Tech Stack

* **SwiftUI** (iOS 16+)
* **Firebase** (Auth, Firestore, Storage, Functions)
* **OpenAI SDK** (via Firebase Functions)
* **MapKit** (local resource discovery)
* **Agora SDK** (video calls)
* **CocoaPods** & **Swift Package Manager**
* **Node.js 18/20** for Firebase backend
* **Multilingual `.strings` Localization**

---

## 📁 Project Structure

RefugeGuide/
├── Views/
│   ├── OnboardingViews/
│   ├── DashboardViews/
│   ├── DocumentViews/
│   ├── ConsultationViews/
│   ├── CommunityViews/
│   ├── LocalServices/
│   ├── Help/
│   ├── SettingsViews/
│   ├── Components/
├── Models/
├── Services/
├── Utilities/
├── ViewModels/
├── Resources/ (e.g. Localizable.xcstrings)
├── Firebase/ (functions/chatWithGPT)

---

## 🔐 Security

Sensitive keys like `GoogleService-Info.plist` are excluded from the repo and managed via `.gitignore`.

---

## 📦 Backend Setup

* `firebase init functions` in `refugeguide2025/`
* Installed OpenAI SDK + Firebase Admin SDK
* Created `chatWithGPT` function using Node.js 18 (deployed via Node.js 20)
* Secured OpenAI API key via environment config
* ✅ Deployed & tested via Firebase CLI

---

## 👥 Credits

Developed with input from UK refugee organizations and trauma-informed design principles.

---

## 📄 License

MIT License – use freely, contribute openly, protect privacy.
