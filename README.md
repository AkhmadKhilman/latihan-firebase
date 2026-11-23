# Flutter Firebase Authentication & User Dashboard

Repositori ini berisi implementasi aplikasi Flutter yang mengintegrasikan **Firebase Authentication**. Aplikasi ini dirancang untuk mendemonstrasikan alur autentikasi pengguna (Login & Logout), manajemen _state_ sesi secara _real-time_, serta menampilkan detail metadata pengguna yang sedang _login_ ke dalam sebuah _dashboard_.

## 📥 Download APK

Jika kamu hanya ingin mencoba aplikasinya tanpa harus melakukan _compile_ kode sumbernya, kamu bisa langsung mengunduh file APK yang sudah jadi melalui halaman **Releases**.

👉 **[Klik di sini untuk mengunduh APK terbaru](../../releases)** _(Sesuaikan tautan ini nanti, atau arahkan user untuk klik menu "Releases" di sebelah kanan halaman GitHub ini)_.

## Data Login

untuk masuk silahkan masukkan
Email : khilman3570@gmail.com
Password : madman2020

## ✨ Fitur Utama

- **Manajemen Sesi Otomatis (Reactive Routing):** Menggunakan `StreamBuilder` untuk mendengarkan perubahan status autentikasi (`authStateChanges`). Aplikasi akan secara otomatis mengarahkan pengguna ke halaman _Dashboard_ jika sesi masih aktif, atau ke halaman _Login_ jika belum _login_.
- **Validasi Form Login:** Pengecekan input secara langsung pada sisi klien (email kosong, format `@` tidak valid, dan password kosong).
- **Penanganan Error (Error Handling) yang Informatif:** Menangkap _exception_ spesifik dari Firebase (seperti `too-many-requests` dan `user-disabled`) dan menampilkannya kepada pengguna menggunakan `SnackBar` yang responsif.
- **Dashboard Pengguna (Profile):** Mengambil dan menampilkan data pengguna yang tersimpan di Firebase, meliputi:
  - Foto Profil (`CircleAvatar` via URL jaringan)
  - UUID (Unique User ID)
  - Nama Tampilan (_Display Name_)
  - Alamat Email & Status Verifikasi Email
  - Waktu Terakhir Login (_Last Sign-In Time_)
- **Fungsi Logout:** Mengakhiri sesi pengguna dengan aman dan langsung mengembalikan antarmuka ke halaman Login.

## 🛠️ Teknologi yang Digunakan

- **Framework:** [Flutter](https://flutter.dev/)
- **Bahasa Pemrograman:** Dart
- **Backend/BaaS:** [Firebase Authentication](https://firebase.google.com/docs/auth)
- **Packages:**
  - `firebase_core` (Inisialisasi Firebase)
  - `firebase_auth` (Layanan Autentikasi)

## 📸 Pratinjau Layar (Screenshots)

_(Tambahkan gambar screenshot aplikasi kamu di sini)_

|        Halaman Login         |          Halaman Dashboard           |
| :--------------------------: | :----------------------------------: |
| `![Login](assets/login.png)` | `![Dashboard](assets/dashboard.png)` |

## 🚀 Cara Instalasi dan Penggunaan (Untuk Developer)

Ikuti langkah-langkah berikut untuk menjalankan project ini di komputer lokal kamu.

### 1. Persyaratan Sistem

- Flutter SDK telah terinstal dan terkonfigurasi.
- Emulator Android/iOS atau perangkat fisik untuk _testing_.
- Akun Google/Firebase aktif.
- [Firebase CLI](https://firebase.google.com/docs/cli) dan [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) telah terinstal.

### 2. Kloning Repositori

```bash
git clone https://github.com/username-kamu/nama-repo-kamu.git
cd nama-repo-kamu
```

### 3. Unduh Dependencies

Jalankan perintah ini untuk mengunduh semua _package_ yang dibutuhkan:

```bash
flutter pub get
```

### 4. Konfigurasi Firebase (FlutterFire)

Karena file `firebase_options.dart` terikat dengan project Firebase milik pembuat asli dan tidak diunggah ke GitHub demi keamanan, kamu harus menghubungkan project ini dengan project Firebase kamu sendiri:

1. Buat project baru di [Firebase Console](https://console.firebase.google.com/).
2. Buka terminal di dalam folder project Flutter ini dan jalankan:
   ```bash
   flutterfire configure
   ```
3. Pilih project Firebase yang baru kamu buat dan centang _platform_ yang ingin kamu dukung (Android/iOS).
4. Masuk ke Firebase Console > **Authentication** > **Sign-in method**, lalu aktifkan **Email/Password**.
5. Tambahkan minimal satu pengguna (Email & Password) di tab **Users** pada Firebase Console untuk keperluan _testing login_.

### 5. Jalankan Aplikasi

Setelah konfigurasi selesai, jalankan aplikasi menggunakan perintah:

```bash
flutter run
```

## 📂 Struktur Kode

- **`main()`**: Fungsi utama yang memastikan _binding_ Flutter berjalan dan menginisialisasi `Firebase.initializeApp` sebelum merender UI.
- **`MyApp`**: Mengatur _root_ aplikasi dan tema global (menggunakan `ColorScheme` berbasis _seed color_).
- **`AuthenticationApp`**: Widget yang bertugas sebagai _router_ penengah. Menampilkan _loading indicator_ saat memuat data, mengarahkan ke `MyHomePage` jika `snapshot.hasData` (user login), atau ke `MyLoginPage` jika tidak ada sesi.
- **`MyLoginPage`**: Layar UI yang memuat `Form`, `TextFormField` (dengan validasi), dan tombol _Login_. Berisi logika `_login()` untuk melakukan autentikasi ke Firebase.
- **`MyHomePage`**: Layar _Dashboard_ yang menerima parameter `User` dan menampilkan detail informasinya di dalam _Card_, serta menyediakan fungsi `_logout()`.

## 📝 Catatan Penting

- Pada kode saat ini, foto profil dirender menggunakan `NetworkImage(user.photoURL!)`. Pastikan akun percobaan yang kamu gunakan di Firebase memiliki _URL_ foto profil yang valid untuk menghindari error _Null Pointer_, atau tambahkan validasi _null-check_ jika pengguna belum mengunggah foto.

---

Dibuat dengan ❤️ menggunakan Flutter.
