# ZNMC APK
Build otomatis lewat GitHub Actions (tanpa Android Studio):
1. Buat repo GitHub baru (boleh private), upload SEMUA isi folder ini (termasuk folder .github).
2. Tab Actions -> "Build ZNMC APK" -> Run workflow (tunggu +-5-10 menit).
3. Buka run yang selesai -> Artifacts -> ZNMC-apk -> unduh, ekstrak, pasang app-debug.apk di HP.

Build manual (butuh Node 20, JDK 17, Android SDK): npm install && npx cap add android && npx cap sync android && cd android && ./gradlew assembleDebug
Perbarui aplikasi: ganti www/index.html dengan ZNMC.html terbaru lalu build ulang.
