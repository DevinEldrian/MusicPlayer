# Melo Private Vault — Setup Supabase & GitHub Pages

Aplikasi web siap dipasang di `index.html` (root) dan `docs/index.html` (Pages `/docs`). File lama dan build APK tetap ada.

## 1. Siapkan Supabase

1. Masuk [Supabase Dashboard](https://supabase.com/dashboard), buat atau pilih project khusus musikmu.
2. Jalankan isi [`supabase/melo_private_schema.sql`](supabase/melo_private_schema.sql) di **SQL Editor → New Query → Run**. Ini membuat tabel `melo_tracks` dengan RLS, dan bucket **`melo-private` (private)** dengan kebijakan hanya pemilik (`auth.uid()`). **Jangan buat bucket public**.
3. Di **Authentication → Providers**, aktifkan **Email**. Email confirmation dianjurkan.
4. Di **Authentication → URL Configuration**, set **Site URL** menjadi `https://devineldrian.github.io/MusicPlayer/` dan tambahkan **Redirect URLs** berikut:
   - `https://devineldrian.github.io/MusicPlayer/`
   - `https://devineldrian.github.io/MusicPlayer/docs/`
5. Di **Project Settings → API Keys**, salin **Project URL** dan **Publishable key** (atau legacy `anon` key). **Jangan** pakai `service_role` atau secret key.
6. Edit [`docs/cloud-config.js`](docs/cloud-config.js) pada GitHub (klik pencil), dengan nilai project yang benar:

   ```js
   window.MELO_CLOUD_CONFIG = {
     url: "https://PROJECT_ID.supabase.co",
     publishableKey: "sb_publishable_xxx"
   };
   ```

   File itu dibaca dari halaman root maupun `/docs`, jadi cukup edit **satu file**.

## 2. Gunakan di website

1. Setelah GitHub Pages deploy terbaru sukses, refresh `https://devineldrian.github.io/MusicPlayer/`.
2. Klik **Login**, pilih **Daftar** (jika perlu), verifikasi email, lalu login.
3. Klik **Upload Cloud** untuk unggah lagu ke bucket privat. Musik, cover (kalau ada), dan metadatanya disimpan di Supabase.
4. Atau jika kamu sudah menyimpan lagu lokal dalam browser dan masih ada di pustaka yang sama, pilih **Backup semua lagu lokal** untuk menyalinnya ke cloud.
5. Buka situs yang sama di HP/PC lain, login dengan akun yang sama; pustaka yang sama muncul. Sinkronisasi dipicu saat login, saat tab difokuskan, dan berkala. Favorit/lirik/statistik diperbarui ke akun cloud.

## 3. Keamanan & batasan

- **Private bukan DRM**: playlist tidak publik dan bucket tertutup. Player mengambil *signed audio URLs* yang berlaku kira-kira satu jam; siapa pun yang mendapatkan link sementara itu dapat membukanya sampai kedaluwarsa.
- Repo GitHub Pages **publik**. Simpan **hanya** Project URL dan publishable/anon key di `cloud-config.js`, bukan password, `service_role` atau secret API keys. RLS wajib diaktifkan.
- Supabase tier gratis dapat membatasi unggahan hingga **50 MB/file**. Versi ini menggunakan upload biasa untuk file sampai 50 MB; file FLAC yang lebih besar membutuhkan upgrade batas dan implementasi upload resumable.
- Audio lokal di IndexedDB tidak otomatis berpindah saat login: gunakan **Backup semua lagu lokal**, atau upload dari perangkat yang menyimpan file asli. Lagu lokal tetap berada di perangkat sesudah di-backup.
- Jangan mengunggah musik berhak cipta jika kamu tidak memiliki hak menyimpan/meng-host salinannya di layanan tersebut. Periksa juga ketentuan layanan cloud.
- Musik cloud tidak pernah diunggah ke GitHub. Jangan menggunakan fitur **Paket Online** lama untuk koleksi privat; ZIP itu dibuat untuk penerbitan publik, berbeda dari **Upload Cloud** yang terenkripsi saat transit dan memakai RLS.
- Mode offline hanya untuk lagu lokal. Streaming butuh akses jaringan ke Supabase; layanan dapat mengenakan biaya storage/bandwidth tergantung kuota.
- Supabase Auth menyimpan sesi pengguna di browser agar tetap login. Logout menghilangkan daftar lagu cloud dari layar saat itu, tetapi tidak menghapus musik di cloud.

## Troubleshooting

- **Cloud belum dikonfigurasi**: edit `docs/cloud-config.js`, lalu refresh (Ctrl+Shift+R).
- **Login belum berhasil**: periksa verifikasi email dan Redirect URLs di Supabase Auth.
- **new row violates row-level security policy**: SQL policy belum diterapkan; pastikan storage private dan tabel memakai RLS.
- **Upload gagal >50 MB**: kecilkan ukuran atau tingkatkan batas dan gunakan upload resumable.
- **Format gagal diputar**: bergantung dukungan codec browser (beberapa browser tidak mendukung FLAC/ALAC tertentu).
- **Pindah domain/branch Pages**: perbarui URL Configuration Supabase.

Untuk pengujian keamanan, coba akun kedua: akun kedua tidak boleh dapat membaca, memutar, atau menghapus objek milik akun pertama. SQL policy berbasis `auth.uid()` berlaku di server, bukan hanya UI.
