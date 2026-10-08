# Melo Player Premium (Web)

Versi web terpisah dari APK ZNMC lama yang tetap berada di folder `www/`. Situs statis berada di `docs/index.html`.

## Aktifkan online melalui GitHub Pages
1. Buka **Settings → Pages** di repository.
2. Pada **Build and deployment**, pilih **Deploy from a branch**.
3. Pilih **main**, folder **/docs**, lalu **Save**.
4. Akses **https://devineldrian.github.io/MusicPlayer/** setelah proses publish berhasil.

## Koleksi musik lokal dan online
- Tombol **Tambah Musik** mengimpor MP3, FLAC, M4A, WAV, OGG (tergantung browser). Lagu lokal disimpan di IndexedDB browser/perangkat itu saja, bukan di GitHub. Ganti perangkat, domain, atau hapus data browser = koleksi tidak otomatis terbawa.
- Tombol **Tambah URL** menambahkan streaming dari tautan langsung HTTP(S) yang didukung browser; daftar tautan disimpan di perangkat tersebut.
- Agar lagu tersedia di perangkat lain, gunakan manifest `docs/music/library.json` dan file audio yang di-host. Misalnya: `{"tracks":[{"title":"Demo","artist":"Example","url":"music/tracks/demo.mp3"}]}` dengan audio di `docs/music/tracks/demo.mp3`.

## Pindahkan koleksi tersimpan menjadi pustaka online
1. Buka versi Melo Premium **pada origin yang sama** tempat lagu lama disimpan. IndexedDB berbeda pada file lokal, localhost dan GitHub Pages; bila belum muncul, impor ulang lagu ke Melo Premium.
2. Klik **Paket Online ↓** untuk mengunduh `melo-cloud-library.zip`, berisi audio, cover, dan manifest `music/library.json`.
3. Ekstrak ZIP dan upload isi folder `music/` ke `docs/music/` pada repository GitHub. Ganti `docs/music/library.json` yang kosong.
4. Setelah GitHub Pages selesai publish, refresh halaman. Koleksi yang di-host dapat diputar di berbagai perangkat.

**PENTING:** Repository dan GitHub Pages ini **publik**. File lagu yang di-upload akan dapat diakses publik. Jangan unggah rekaman berhak cipta tanpa izin distribusi, atau koleksi yang ingin dijaga privasinya. Gunakan penyimpanan privat yang memerlukan autentikasi untuk musik pribadi. Batas GitHub Pages untuk situs publik sekitar 1 GB; tiap file GitHub maksimal 100 MB.

## Fitur
Tampilan responsive, mini-player, favorit, statistik, shuffle/repeat, impor metadata ID3/FLAC, lirik LRC & pencarian LRCLIB (bila tersedia), streaming URL dan ZIP export. Visualizer adalah animasi ambience, bukan analisis spektrum langsung agar streaming lintas domain tetap bisa diputar.
