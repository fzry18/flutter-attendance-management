# 📚 Panduan Posting ke GitHub

## 🚀 Langkah-langkah Upload Proyek ke GitHub

### 1. Persiapan Proyek

```bash
# Masuk ke direktori proyek
cd d:\kodingan\flutter-project\presence

# Inisialisasi Git (jika belum)
git init

# Tambahkan file .gitignore untuk Flutter
# (File .gitignore sudah ada, pastikan lengkap)
```

### 2. Konfigurasi Git

```bash
# Set username dan email Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Atau untuk proyek ini saja
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### 3. Staging dan Commit

```bash
# Tambahkan semua file ke staging
git add .

# Commit pertama
git commit -m "🎉 Initial commit: Flutter Attendance Management System

✨ Features:
- Employee attendance tracking with GPS location
- Real-time attendance monitoring
- Role-based access (Admin/Employee)
- Firebase Authentication & Firestore
- Material Design 3 UI/UX
- Date range filtering with Syncfusion DatePicker
- Attendance statistics and reports"
```

### 4. Buat Repository di GitHub

1. Buka https://github.com
2. Login ke akun GitHub Anda
3. Klik tombol "New" atau "+" → "New repository"
4. Isi detail repository:
   - **Repository name**: `flutter-attendance-management`
   - **Description**: `🏢 Modern Flutter attendance management system with GPS tracking, Firebase integration, and Material Design 3 UI`
   - **Visibility**: Public (untuk portfolio)
   - ✅ **Add a README file**: TIDAK (karena kita sudah punya)
   - ✅ **Add .gitignore**: TIDAK (sudah ada)
   - **Choose a license**: MIT License (opsional)

### 5. Hubungkan dengan Remote Repository

```bash
# Tambahkan remote origin
git remote add origin https://github.com/YOUR_USERNAME/flutter-attendance-management.git

# Pastikan branch utama bernama 'main'
git branch -M main

# Push ke GitHub
git push -u origin main
```

### 6. Setup Repository GitHub (Opsional)

- **Topics/Tags**: Tambahkan tags seperti: `flutter`, `dart`, `firebase`, `attendance`, `gps`, `material-design`, `mobile-app`
- **About**: Isi deskripsi singkat
- **Website**: Link ke demo atau dokumentasi (jika ada)

### 7. Commit Selanjutnya

```bash
# Untuk update selanjutnya
git add .
git commit -m "✨ Add new feature: [deskripsi fitur]"
git push origin main
```

## 📝 Tips untuk Commit Messages

Gunakan format conventional commits:

- `feat:` untuk fitur baru
- `fix:` untuk bug fixes
- `docs:` untuk dokumentasi
- `style:` untuk formatting
- `refactor:` untuk refactoring code
- `test:` untuk testing
- `chore:` untuk maintenance

### Contoh:

```bash
git commit -m "feat: add date range filter for attendance records

- Implement Syncfusion DatePicker for date selection
- Add real-time filtering in statistics
- Improve user experience with clear date indicators"
```

## 🔒 Keamanan

⚠️ **PENTING**: Pastikan file berikut TIDAK di-commit:

- `android/app/google-services.json` (sudah di .gitignore)
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart` (jika berisi keys sensitif)
- File `.env` atau konfigurasi API keys

## 📱 Langkah Selanjutnya

1. Buat GitHub Pages untuk dokumentasi (opsional)
2. Setup GitHub Actions untuk CI/CD (opsional)
3. Buat release tags untuk versi stabil
4. Tambahkan contributors dan maintainers
