import '../providers/settings_provider.dart';

class AppLocalizations {
  final AppLanguage language;
  AppLocalizations(this.language);

  static final Map<String, Map<AppLanguage, String>> _localizedValues = {
    // Navigation & Tabs
    'dasbor': {
      AppLanguage.id: 'Dasbor',
      AppLanguage.en: 'Dashboard',
      AppLanguage.ban: 'Dasbor',
    },
    'scan': {
      AppLanguage.id: 'Pindai',
      AppLanguage.en: 'Scan',
      AppLanguage.ban: 'Pindai',
    },
    'panduan': {
      AppLanguage.id: 'Panduan',
      AppLanguage.en: 'Guide',
      AppLanguage.ban: 'Negesin',
    },
    'profil': {
      AppLanguage.id: 'Profil',
      AppLanguage.en: 'Profile',
      AppLanguage.ban: 'Profil',
    },

    // Profile Screen
    'profil_saya': {
      AppLanguage.id: 'Profil Saya',
      AppLanguage.en: 'My Profile',
      AppLanguage.ban: 'Profil Tiang',
    },
    'statistik_pemilahan': {
      AppLanguage.id: 'Statistik Pemilahan',
      AppLanguage.en: 'Sorting Statistics',
      AppLanguage.ban: 'Statistik Pemilahan',
    },
    'total_scan': {
      AppLanguage.id: 'Total Scan',
      AppLanguage.en: 'Total Scans',
      AppLanguage.ban: 'Total Scan',
    },
    'organik': {
      AppLanguage.id: 'Organik',
      AppLanguage.en: 'Organic',
      AppLanguage.ban: 'Organik',
    },
    'non_organik': {
      AppLanguage.id: 'Non-Organik',
      AppLanguage.en: 'Non-Organic',
      AppLanguage.ban: 'Non-Organik',
    },
    'residu': {
      AppLanguage.id: 'Residu',
      AppLanguage.en: 'Residue',
      AppLanguage.ban: 'Residu',
    },
    'preferensi': {
      AppLanguage.id: 'Preferensi',
      AppLanguage.en: 'Preferences',
      AppLanguage.ban: 'Preferensi',
    },
    'mode_gelap': {
      AppLanguage.id: 'Mode Gelap',
      AppLanguage.en: 'Dark Mode',
      AppLanguage.ban: 'Mode Gelap',
    },
    'mode_terang': {
      AppLanguage.id: 'Mode Terang',
      AppLanguage.en: 'Light Mode',
      AppLanguage.ban: 'Mode Terang',
    },
    'mengikuti_sistem': {
      AppLanguage.id: 'Mengikuti pengaturan sistem',
      AppLanguage.en: 'Follow system settings',
      AppLanguage.ban: 'Nyenutin setelan sistem',
    },
    'bahasa': {
      AppLanguage.id: 'Bahasa',
      AppLanguage.en: 'Language',
      AppLanguage.ban: 'Bahasa',
    },
    'tentang_aplikasi': {
      AppLanguage.id: 'Tentang Aplikasi',
      AppLanguage.en: 'About Application',
      AppLanguage.ban: 'Tentang Aplikasi',
    },
    'versi': {
      AppLanguage.id: 'Versi',
      AppLanguage.en: 'Version',
      AppLanguage.ban: 'Versi',
    },
    'keluar': {
      AppLanguage.id: 'Keluar (Logout)',
      AppLanguage.en: 'Logout',
      AppLanguage.ban: 'Mekaad (Logout)',
    },
    'edit_profil': {
      AppLanguage.id: 'Edit Profil',
      AppLanguage.en: 'Edit Profile',
      AppLanguage.ban: 'Ngubah Profil',
    },
    'nama_lengkap': {
      AppLanguage.id: 'Nama Lengkap',
      AppLanguage.en: 'Full Name',
      AppLanguage.ban: 'Wasta Jangkep',
    },
    'wilayah': {
      AppLanguage.id: 'Wilayah (Kecamatan/Kabupaten)',
      AppLanguage.en: 'Region (District/Regency)',
      AppLanguage.ban: 'Wewidangan (Kecamatan/Kabupaten)',
    },
    'batal': {
      AppLanguage.id: 'Batal',
      AppLanguage.en: 'Cancel',
      AppLanguage.ban: 'Batal',
    },
    'simpan': {
      AppLanguage.id: 'Simpan',
      AppLanguage.en: 'Save',
      AppLanguage.ban: 'Simpen',
    },
    'nama_kosong': {
      AppLanguage.id: 'Nama tidak boleh kosong',
      AppLanguage.en: 'Name cannot be empty',
      AppLanguage.ban: 'Wasta nenten dados puyung',
    },
    'profil_sukses': {
      AppLanguage.id: 'Profil berhasil diperbarui',
      AppLanguage.en: 'Profile updated successfully',
      AppLanguage.ban: 'Profil kasidang kaanyarin',
    },
    'profil_gagal': {
      AppLanguage.id: 'Gagal memperbarui profil',
      AppLanguage.en: 'Failed to update profile',
      AppLanguage.ban: 'Pecundangan nganyarin profil',
    },

    // Home/Scan Screen
    'pindai_sampah': {
      AppLanguage.id: 'Pindai Sampah',
      AppLanguage.en: 'Scan Waste',
      AppLanguage.ban: 'Pindai Luu',
    },
    'ambil_foto': {
      AppLanguage.id: 'Ambil Foto',
      AppLanguage.en: 'Take Photo',
      AppLanguage.ban: 'Jemak Foto',
    },
    'pilih_galeri': {
      AppLanguage.id: 'Pilih Galeri',
      AppLanguage.en: 'Choose Gallery',
      AppLanguage.ban: 'Pilih Galeri',
    },
    'pindai_sekarang': {
      AppLanguage.id: 'Pindai Sekarang',
      AppLanguage.en: 'Scan Now',
      AppLanguage.ban: 'Pindai Mangkin',
    },
    'deskripsi_home': {
      AppLanguage.id:
          'Ambil foto sampah atau pilih dari galeri untuk mendeteksi kategori wadah pembuangannya.',
      AppLanguage.en:
          'Take a photo of waste or choose from gallery to detect its disposal container category.',
      AppLanguage.ban:
          'Jemak foto luu utawi pilih saking galeri antuk nguningin genah mabuangnyane.',
    },
    'ambil_atau_pilih_foto_sampah': {
      AppLanguage.id: 'Ambil atau Pilih Foto Sampah',
      AppLanguage.en: 'Take or Choose Waste Photo',
      AppLanguage.ban: 'Jemak utawi Pilih Foto Luu',
    },
    'ai_klasifikasi_deskripsi': {
      AppLanguage.id: 'AI akan mengklasifikasikan sampah ke wadah yang tepat',
      AppLanguage.en: 'AI will classify waste into the appropriate container',
      AppLanguage.ban: 'AI pacang ngelasifikasiang luu ring genah sane patut',
    },
    'kamera': {
      AppLanguage.id: 'Kamera',
      AppLanguage.en: 'Camera',
      AppLanguage.ban: 'Kamera',
    },
    'galeri': {
      AppLanguage.id: 'Galeri',
      AppLanguage.en: 'Gallery',
      AppLanguage.ban: 'Galeri',
    },
    'konteks_tambahan': {
      AppLanguage.id: 'Konteks Tambahan (Opsional)',
      AppLanguage.en: 'Additional Context (Optional)',
      AppLanguage.ban: 'Konteks Tambahan (Opsional)',
    },
    'konteks_hint': {
      AppLanguage.id:
          'Misalnya: "Saya menemukan plastik kemasan ini di pantai"',
      AppLanguage.en: 'Example: "I found this packaging plastic on the beach"',
      AppLanguage.ban:
          'Upami: "Tiang manggihin plastik kemasan puniki ring pasisi"',
    },
    'mulai_klasifikasi': {
      AppLanguage.id: 'Mulai Klasifikasi',
      AppLanguage.en: 'Start Classification',
      AppLanguage.ban: 'Ngawit Klasifikasi',
    },
    'menganalisis_sampah': {
      AppLanguage.id: 'Menganalisis jenis sampah...',
      AppLanguage.en: 'Analyzing waste type...',
      AppLanguage.ban: 'Menganalisis soroh luu...',
    },

    // History Screen
    'riwayat_scan': {
      AppLanguage.id: 'Riwayat Scan',
      AppLanguage.en: 'Scan History',
      AppLanguage.ban: 'Riwayat Scan',
    },
    'hapus_semua': {
      AppLanguage.id: 'Hapus Semua',
      AppLanguage.en: 'Clear All',
      AppLanguage.ban: 'Hapus Makejang',
    },
    'hapus_semua_judul': {
      AppLanguage.id: 'Hapus Semua Riwayat?',
      AppLanguage.en: 'Clear All History?',
      AppLanguage.ban: 'Hapus Makejang Riwayat?',
    },
    'hapus_semua_konfirmasi': {
      AppLanguage.id:
          'Tindakan ini akan menghapus seluruh catatan klasifikasi sampah Anda secara permanen.',
      AppLanguage.en:
          'This action will permanently delete all your waste classification records.',
      AppLanguage.ban:
          'Tindakan puniki pacang ngusap makejang catatan klasifikasi luu Anda sane permanèn.',
    },
    'hapus': {
      AppLanguage.id: 'Hapus',
      AppLanguage.en: 'Delete',
      AppLanguage.ban: 'Usap',
    },
    'riwayat_kosong': {
      AppLanguage.id: 'Belum ada riwayat pemindaian',
      AppLanguage.en: 'No scan history yet',
      AppLanguage.ban: 'Durung wenten riwayat scan',
    },
    'catatan_dihapus': {
      AppLanguage.id: 'Catatan dihapus',
      AppLanguage.en: 'Record deleted',
      AppLanguage.ban: 'Catatan kausap',
    },
    'dampak_lingkungan': {
      AppLanguage.id: 'Dampak Lingkungan Anda',
      AppLanguage.en: 'Your Environmental Impact',
      AppLanguage.ban: 'Dampak Lingkungan Anda',
    },
    'sampah_dipilah': {
      AppLanguage.id: 'Sampah Dipilah',
      AppLanguage.en: 'Waste Sorted',
      AppLanguage.ban: 'Luu Kasoroh',
    },
    'potensi_kompos': {
      AppLanguage.id: 'Potensi Kompos',
      AppLanguage.en: 'Compost Potential',
      AppLanguage.ban: 'Potensi Kompos',
    },
    'didaur_ulang': {
      AppLanguage.id: 'Didaur Ulang',
      AppLanguage.en: 'Recycled',
      AppLanguage.ban: 'Kadaur Ulang',
    },
    'cari_sampah': {
      AppLanguage.id: 'Cari sampah...',
      AppLanguage.en: 'Search waste...',
      AppLanguage.ban: 'Ngrereh luu...',
    },
    'semua': {
      AppLanguage.id: 'Semua',
      AppLanguage.en: 'All',
      AppLanguage.ban: 'Makejang',
    },
    'belum_ada_pemindaian': {
      AppLanguage.id: 'Belum Ada Pemindaian',
      AppLanguage.en: 'No Scans Yet',
      AppLanguage.ban: 'Durung Wenten Pemindaian',
    },
    'hasil_tidak_ditemukan': {
      AppLanguage.id: 'Hasil Tidak Ditemukan',
      AppLanguage.en: 'No Results Found',
      AppLanguage.ban: 'Pikolih Nenten Kapanggih',
    },
    'mulai_pindai_hint': {
      AppLanguage.id:
          'Mulai pindai foto sampah Anda di tab Pindai untuk melihat catatan riwayat di sini.',
      AppLanguage.en:
          'Start scanning waste photos in the Scan tab to see history records here.',
      AppLanguage.ban:
          'Ngawit pindai foto luu ring tab Pindai antuk manggihin catatan riwayat driki.',
    },
    'ubah_kata_kunci_hint': {
      AppLanguage.id:
          'Cobalah mengubah kata kunci pencarian Anda atau ganti filter kategori.',
      AppLanguage.en:
          'Try changing your search keyword or switch the category filter.',
      AppLanguage.ban:
          'Coba ngubah kata kunci pangandikaane utawi ganti filter kategori.',
    },
    'menit_lalu': {
      AppLanguage.id: 'menit lalu',
      AppLanguage.en: 'min ago',
      AppLanguage.ban: 'menit sampun',
    },
    'jam_lalu': {
      AppLanguage.id: 'jam lalu',
      AppLanguage.en: 'hrs ago',
      AppLanguage.ban: 'jam sampun',
    },

    // Guide Screen
    'panduan_pemilahan': {
      AppLanguage.id: 'Panduan Pemilahan',
      AppLanguage.en: 'Sorting Guide',
      AppLanguage.ban: 'Negesin Pemilahan',
    },
  };

  String get(String key) {
    final values = _localizedValues[key];
    if (values == null) return key;
    return values[language] ?? values[AppLanguage.id] ?? key;
  }
}
