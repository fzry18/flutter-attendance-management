# 🏢 Flutter Attendance Management System

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

**Modern attendance management system with GPS tracking, real-time monitoring, and beautiful Material Design 3 UI**

[📱 Demo](#demo) • [🚀 Features](#features) • [🛠️ Installation](#installation) • [📖 Documentation](#documentation)

</div>

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

Flutter Attendance Management System adalah aplikasi mobile modern yang dirancang untuk mengelola presensi karyawan dengan teknologi GPS tracking dan real-time monitoring. Aplikasi ini dibangun menggunakan Flutter dengan Material Design 3 dan terintegrasi dengan Firebase untuk backend services.

### 🎯 Goals

- Menyediakan sistem presensi yang akurat dengan GPS tracking
- Memberikan pengalaman user yang intuitif dan modern
- Memungkinkan monitoring real-time untuk admin
- Menghasilkan laporan presensi yang komprehensif

## ✨ Features

### 👥 User Management

- **🔐 Firebase Authentication** - Login/Register dengan email verification
- **👤 Role-based Access Control** - Admin dan Employee dengan hak akses berbeda
- **🔄 Password Reset** - Forgot password via email
- **✅ Email Verification** - Mandatory email verification for security

### 📍 Attendance Tracking

- **📱 GPS Location Tracking** - Automatic location detection saat check-in/out
- **🏢 Office Area Validation** - Validasi lokasi dalam/luar area kantor
- **⏰ Real-time Clock** - Tampilan jam real-time untuk presensi
- **📊 Attendance Status** - Status hadir, terlambat, atau di luar area

### 📈 Dashboard & Analytics

- **📊 Statistics Overview** - Total hari kerja, kehadiran, dan luar area
- **📅 Calendar Integration** - Tampilan kalender dengan status presensi
- **🔍 Advanced Filtering** - Filter berdasarkan tanggal dengan Syncfusion DatePicker
- **📱 Responsive Design** - Optimized untuk berbagai ukuran layar

### 👨‍💼 Admin Features

- **➕ Employee Management** - Tambah/edit data karyawan
- **👀 Real-time Monitoring** - Monitor presensi semua karyawan
- **📋 Attendance Reports** - Generate laporan presensi komprehensif
- **⚙️ System Configuration** - Pengaturan area kantor dan jam kerja

### 🎨 UI/UX Features

- **🎨 Material Design 3** - Latest Material Design guidelines
- **🌙 Modern Interface** - Clean and intuitive user interface
- **📱 Adaptive Layout** - Responsive design untuk semua device
- **🔄 Smooth Animations** - Fluid transitions dan micro-interactions
- **🎯 User-friendly Navigation** - Intuitive navigation dengan bottom bar

## 📱 Screenshots

### Authentication Flow

|             Login Screen             |              Register Screen               |                 Email Verification                 |
| :----------------------------------: | :----------------------------------------: | :------------------------------------------------: |
| ![Login](docs/screenshots/login.png) | ![Register](docs/screenshots/register.png) | ![Verification](docs/screenshots/verification.png) |

### Main Application

|                  Dashboard                   |                   Attendance                   |                 Profile                  |
| :------------------------------------------: | :--------------------------------------------: | :--------------------------------------: |
| ![Dashboard](docs/screenshots/dashboard.png) | ![Attendance](docs/screenshots/attendance.png) | ![Profile](docs/screenshots/profile.png) |

### Admin Features

|                Employee List                 |                    Add Employee                    |            Attendance Report             |
| :------------------------------------------: | :------------------------------------------------: | :--------------------------------------: |
| ![Employees](docs/screenshots/employees.png) | ![Add Employee](docs/screenshots/add_employee.png) | ![Reports](docs/screenshots/reports.png) |

## 🛠️ Tech Stack

### Frontend

- **[Flutter](https://flutter.dev/)** (3.8.1+) - UI framework
- **[Dart](https://dart.dev/)** (3.8.1+) - Programming language
- **[GetX](https://pub.dev/packages/get)** (4.7.2) - State management & routing
- **[Material Design 3](https://m3.material.io/)** - Design system

### Backend & Services

- **[Firebase Authentication](https://firebase.google.com/products/auth)** - User authentication
- **[Cloud Firestore](https://firebase.google.com/products/firestore)** - NoSQL database
- **[Firebase Storage](https://firebase.google.com/products/storage)** - File storage

### Key Packages

- **[Geolocator](https://pub.dev/packages/geolocator)** (14.0.2) - GPS location services
- **[Geocoding](https://pub.dev/packages/geocoding)** (4.0.0) - Address conversion
- **[Syncfusion DatePicker](https://pub.dev/packages/syncfusion_flutter_datepicker)** (30.1.42) - Advanced date selection
- **[Intl](https://pub.dev/packages/intl)** (0.19.0) - Internationalization
- **[Convex Bottom Bar](https://pub.dev/packages/convex_bottom_bar)** (3.2.0) - Modern navigation

## 🏗️ Architecture

```
lib/
├── app/
│   ├── data/                 # Data layer
│   │   ├── models/          # Data models
│   │   └── services/        # API services
│   ├── modules/             # Feature modules
│   │   ├── home/           # Dashboard module
│   │   ├── login/          # Authentication
│   │   ├── profile/        # User profile
│   │   ├── add_pegawai/    # Employee management
│   │   └── all_presensi/   # Attendance records
│   └── routes/             # App routing
├── firebase_options.dart   # Firebase configuration
└── main.dart              # App entry point
```

### Design Patterns

- **MVC Pattern** dengan GetX Controller
- **Repository Pattern** untuk data access
- **Observer Pattern** untuk reactive programming
- **Singleton Pattern** untuk services

## 🚀 Installation

### Prerequisites

- **Flutter SDK** (3.8.1 atau lebih baru)
- **Dart SDK** (3.8.1 atau lebih baru)
- **Android Studio** atau **VS Code**
- **Firebase Project** dengan Authentication dan Firestore enabled

### Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/flutter-attendance-management.git
cd flutter-attendance-management
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Firebase Setup

1. Buat project baru di [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication** dengan Email/Password provider
3. Enable **Cloud Firestore** database
4. Download `google-services.json` untuk Android
5. Download `GoogleService-Info.plist` untuk iOS
6. Letakkan file konfigurasi di direktori yang sesuai:
   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```

### Step 4: Configure Firebase

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize FlutterFire
dart pub global activate flutterfire_cli
flutterfire configure
```

### Step 5: Run Application

```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

## ⚙️ Configuration

### Firebase Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /pegawai/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Presensi subcollection
      match /presensi/{presensiId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Admin can access all data
    match /{document=**} {
      allow read, write: if request.auth != null &&
        get(/databases/$(database)/documents/pegawai/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### Location Permissions

Tambahkan permissions di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

## 📖 Usage

### For Employees

1. **Register/Login** dengan email corporate
2. **Verify Email** melalui link yang dikirim
3. **Check-in** saat tiba di kantor
4. **Check-out** saat pulang kerja
5. **View History** presensi dan statistik

### For Admins

1. **Login** dengan akun admin
2. **Add Employees** dengan form yang disediakan
3. **Monitor Attendance** real-time semua karyawan
4. **Generate Reports** berdasarkan periode tertentu
5. **Manage Settings** area kantor dan jam kerja

## 🤝 Contributing

Kami menyambut kontribusi dari developer lain! Berikut cara berkontribusi:

### Development Setup

```bash
# Fork repository
git clone https://github.com/YOUR_USERNAME/flutter-attendance-management.git

# Create feature branch
git checkout -b feature/amazing-feature

# Commit changes
git commit -m 'Add amazing feature'

# Push to branch
git push origin feature/amazing-feature

# Open Pull Request
```

### Code Style

- Gunakan **Dart formatting** dengan `dart format`
- Follow **Flutter best practices**
- Tambahkan **comments** untuk kode kompleks
- Write **unit tests** untuk fitur baru

### Commit Convention

```
feat: add new feature
fix: bug fix
docs: documentation update
style: formatting changes
refactor: code refactoring
test: add tests
chore: maintenance
```

## 🐛 Known Issues

- [ ] Background location tracking needs improvement
- [ ] Offline mode not fully supported
- [ ] Push notifications for attendance reminders

## 🔮 Roadmap

- [ ] **Push Notifications** - Reminder untuk check-in/out
- [ ] **Offline Support** - Sync data saat online kembali
- [ ] **Biometric Authentication** - Fingerprint/Face ID
- [ ] **Advanced Analytics** - Dashboard analytics yang lebih detail
- [ ] **Multi-language Support** - Bahasa Indonesia dan Inggris
- [ ] **Dark Mode** - Theme switching
- [ ] **Export Reports** - Export ke PDF/Excel

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**

- GitHub: [@your-username](https://github.com/your-username)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/your-profile)
- Email: your.email@example.com

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) untuk framework yang luar biasa
- [Firebase Team](https://firebase.google.com/) untuk backend services
- [Material Design](https://material.io/) untuk design guidelines
- [Syncfusion](https://www.syncfusion.com/) untuk komponen UI yang powerful

## 📞 Support

Jika Anda mengalami masalah atau memiliki pertanyaan:

1. **Check Issues** - Lihat [GitHub Issues](../../issues) untuk masalah yang sudah ada
2. **Create Issue** - Buat issue baru jika belum ada
3. **Contact** - Email ke your.email@example.com

---

<div align="center">

**⭐ Jika project ini membantu Anda, berikan star di GitHub! ⭐**

Made with ❤️ using Flutter

</div>
