# Morning Prep Assistant Implementation Tasks

Dokumen ini memecah konsep di [AGENTS.md](/Users/academy/Desktop/ytta/AGENTS.md) menjadi task teknis per file untuk project SwiftUI `ytta`.

## HIG requirement

Semua implementasi visual dan interaksi harus mengikuti Apple Human Interface Guidelines. Artinya, setiap keputusan UI harus memprioritaskan pola native iOS, keterbacaan, kejelasan state, dan navigasi yang familiar dibanding styling yang terlalu custom.

Checklist umum HIG:
- Gunakan komponen native SwiftUI bila sudah cukup
- Pastikan tap target nyaman
- Pastikan hierarchy teks jelas
- Jangan overload satu layar dengan terlalu banyak CTA
- Hormati safe area dan spacing iOS
- Pastikan destructive action memiliki confirmation
- Gunakan semantic colors atau theme yang tetap menjaga kontras
- Pertahankan behavior yang konsisten dengan aplikasi iOS lain

## Target structure

Struktur file yang disarankan untuk MVP:

```text
ytta/
  yttaApp.swift
  ContentView.swift
  Models/
    PrepItem.swift
    TomorrowPrep.swift
  Store/
    PrepStore.swift
  Services/
    NotificationManager.swift
  Views/
    PrepHomeView.swift
    ReadinessCardView.swift
    ChecklistSectionView.swift
    PlanSectionView.swift
    ReminderRowView.swift
    SettingsView.swift
  Design/
    AppTheme.swift
```

## Task breakdown per file

### [ytta/yttaApp.swift](/Users/academy/Desktop/ytta/ytta/yttaApp.swift)

Tujuan:
- Menjadi entry point app
- Inject store global ke root view

Tasks:
- Ganti setup default agar memakai `@StateObject` untuk `PrepStore`
- Inject store ke `ContentView`
- Tentukan tint global jika dibutuhkan
- Pastikan environment setup tidak memaksa pola navigasi yang bertentangan dengan HIG

Definition of done:
- App boot dengan state terpusat
- Semua screen bisa akses store tanpa membuat instance baru

### [ytta/ContentView.swift](/Users/academy/Desktop/ytta/ytta/ContentView.swift)

Tujuan:
- Menjadi container root navigation
- Menampilkan Home screen utama

Tasks:
- Hapus placeholder `Hello, world!`
- Bungkus root di `NavigationStack`
- Render `PrepHomeView`
- Tambahkan tombol menuju `SettingsView`
- Gunakan navigation title dan toolbar placement yang terasa native

Definition of done:
- User langsung masuk ke flow utama saat app dibuka

### [ytta/Models/PrepItem.swift](/Users/academy/Desktop/ytta/ytta/Models/PrepItem.swift)

Tujuan:
- Model item reusable checklist

Tasks:
- Buat `PrepItem: Identifiable, Codable, Hashable`
- Tambahkan field:
  - `id`
  - `title`
  - `isChecked`
  - `isDefault`
- Tambahkan static defaults untuk item awal:
  - charger
  - bottle
  - ID card
  - laptop
  - notebook

Definition of done:
- Item reusable bisa dipakai untuk render list dan persistence

### [ytta/Models/TomorrowPrep.swift](/Users/academy/Desktop/ytta/ytta/Models/TomorrowPrep.swift)

Tujuan:
- Model state utama untuk persiapan besok

Tasks:
- Buat `TomorrowPrep: Codable`
- Tambahkan field:
  - `items: [PrepItem]`
  - `outfit: String`
  - `breakfast: String`
  - `notes: String`
  - `reminderEnabled: Bool`
  - `reminderTime: Date`
- Tambahkan factory/default value untuk first launch

Definition of done:
- Satu object bisa menyimpan seluruh state MVP

### [ytta/Store/PrepStore.swift](/Users/academy/Desktop/ytta/ytta/Store/PrepStore.swift)

Tujuan:
- Single source of truth untuk UI dan persistence

Tasks:
- Buat `ObservableObject`
- Tambahkan `@Published var prep: TomorrowPrep`
- Implement load dari `UserDefaults`
- Implement save ke `UserDefaults`
- Save otomatis saat state berubah
- Tambahkan helper methods:
  - `toggleItem(_:)`
  - `addItem(title:)`
  - `removeItems(at:)`
  - `resetForTomorrow()`
  - `updateReminder(enabled:time:)`
- Tambahkan computed properties:
  - `completionProgress`
  - `readinessStatus`
  - `readinessTitle`
  - `readinessMessage`

Definition of done:
- Semua perubahan UI langsung tersimpan lokal
- Status kesiapan bisa dihitung dari satu tempat

### [ytta/Services/NotificationManager.swift](/Users/academy/Desktop/ytta/ytta/Services/NotificationManager.swift)

Tujuan:
- Menangani local notification reminder malam

Tasks:
- Wrap `UNUserNotificationCenter`
- Tambahkan method:
  - `requestPermission()`
  - `scheduleNightlyReminder(at:)`
  - `cancelNightlyReminder()`
- Gunakan copy:
  - Title: `Prepare for tomorrow`
  - Body: `Take a minute to set out what you need for the morning.`
- Pastikan reschedule saat user mengganti jam reminder

Definition of done:
- Reminder harian bisa dinyalakan, diubah, dan dimatikan

### [ytta/Views/PrepHomeView.swift](/Users/academy/Desktop/ytta/ytta/Views/PrepHomeView.swift)

Tujuan:
- Layar utama untuk seluruh flow inti

Tasks:
- Buat layout `ScrollView`
- Tambahkan header:
  - Title `Prep for Tomorrow`
  - Subtitle pendek yang menenangkan
- Render komponen:
  - `ReadinessCardView`
  - `ChecklistSectionView`
  - `PlanSectionView` untuk outfit
  - `PlanSectionView` untuk breakfast
  - `PlanSectionView` untuk notes
  - `ReminderRowView`
- Tambahkan spacing konsisten dan padding layar
- Pastikan layout tidak terasa padat dan tetap mengikuti ritme spacing iOS

Definition of done:
- User bisa menyelesaikan seluruh prep flow dari satu screen

### [ytta/Views/ReadinessCardView.swift](/Users/academy/Desktop/ytta/ytta/Views/ReadinessCardView.swift)

Tujuan:
- Menampilkan progress dan status kesiapan

Tasks:
- Tampilkan progress ring atau bar
- Tampilkan title status:
  - `Not Ready Yet`
  - `Almost Ready`
  - `Ready for Tomorrow`
- Tampilkan supportive body copy dari store
- Tambahkan animasi halus saat progress berubah
- Gunakan icon yang sesuai status
- Pastikan informasi utama tetap terbaca tanpa bergantung pada warna saja

Definition of done:
- User bisa memahami kesiapan besok dalam sekali lihat

### [ytta/Views/ChecklistSectionView.swift](/Users/academy/Desktop/ytta/ytta/Views/ChecklistSectionView.swift)

Tujuan:
- Menampilkan daftar barang yang harus dibawa

Tasks:
- Tampilkan title `What to Bring`
- Render item checklist dengan button row
- Tampilkan state checked dan unchecked dengan visual jelas
- Hubungkan tap ke `toggleItem(_:)`
- Tampilkan empty state jika item kosong
- Pastikan row height dan tap area memenuhi ekspektasi touch target iOS

Definition of done:
- Checklist terasa cepat dipakai dan mudah dipindai

### [ytta/Views/PlanSectionView.swift](/Users/academy/Desktop/ytta/ytta/Views/PlanSectionView.swift)

Tujuan:
- Komponen reusable untuk outfit, breakfast, dan notes

Tasks:
- Buat card section generik dengan title, icon, placeholder
- Gunakan:
  - `TextField` untuk outfit
  - `TextField` atau `TextEditor` untuk breakfast
  - `TextEditor` untuk notes
- Tambahkan placeholder ringan sesuai isi AGENTS
- Pastikan tinggi input nyaman untuk mobile
- Gunakan semantic font dan input styling yang tetap terasa native

Definition of done:
- Tiga section input bisa dibangun dari satu komponen reusable

### [ytta/Views/ReminderRowView.swift](/Users/academy/Desktop/ytta/ytta/Views/ReminderRowView.swift)

Tujuan:
- CTA cepat untuk reminder dari Home

Tasks:
- Tampilkan status reminder aktif/nonaktif
- Tampilkan jam reminder jika aktif
- Navigasi atau present `SettingsView`
- Jika reminder belum aktif, tampilkan microcopy singkat
- Pastikan CTA reminder terlihat jelas tetapi tidak bersaing dengan task utama

Definition of done:
- User tahu reminder-nya aktif atau belum tanpa masuk settings dulu

### [ytta/Views/SettingsView.swift](/Users/academy/Desktop/ytta/ytta/Views/SettingsView.swift)

Tujuan:
- Mengelola item reusable dan pengaturan reminder

Tasks:
- Tampilkan section `Everyday Items`
- Tambahkan input item baru
- Tambahkan delete item
- Tampilkan section `Nightly Reminder`
- Tambahkan toggle reminder on/off
- Tambahkan `DatePicker` mode time
- Saat reminder berubah, panggil `NotificationManager`
- Tambahkan section reset:
  - Tombol `Reset for Tomorrow`
  - Confirmation dialog sebelum reset
- Gunakan control native dan destructive affordance yang sesuai HIG

Definition of done:
- User bisa personalisasi item dan reminder tanpa flow rumit

### [ytta/Design/AppTheme.swift](/Users/academy/Desktop/ytta/ytta/Design/AppTheme.swift)

Tujuan:
- Menjaga warna dan styling tetap konsisten

Tasks:
- Definisikan color tokens:
  - background
  - surface
  - textPrimary
  - textSecondary
  - accent
  - success
  - warning
  - danger
- Tambahkan helper untuk card styling jika perlu
- Simpan corner radius dan spacing constants
- Pastikan theme tetap menjaga kontras, legibility, dan nuansa native iOS

Definition of done:
- UI tidak hardcode warna di banyak file

## Build order

Urutan implementasi yang paling aman:

1. Buat model di `Models/`
2. Buat `PrepStore`
3. Update `yttaApp.swift`
4. Ubah `ContentView.swift`
5. Buat `PrepHomeView`
6. Buat `ReadinessCardView`
7. Buat `ChecklistSectionView`
8. Buat `PlanSectionView`
9. Buat `SettingsView`
10. Buat `NotificationManager`
11. Rapikan theme di `AppTheme.swift`

## Suggested milestones

### Milestone 1
- Models selesai
- Store selesai
- Data persistence berjalan

### Milestone 2
- Home screen selesai
- Checklist dan input text bekerja
- Readiness status berubah sesuai state

### Milestone 3
- Settings screen selesai
- Reusable items bisa ditambah/hapus
- Reset flow selesai

### Milestone 4
- Reminder notification selesai
- UI polish dan empty states selesai

## QA checklist

- App first launch menampilkan default items
- Checklist item tetap tersimpan setelah app ditutup
- Outfit, breakfast, dan notes tetap tersimpan
- Status berubah dari `Not Ready` ke `Almost Ready` ke `Ready for Tomorrow`
- Reminder bisa aktif dan nonaktif
- Reminder time tersimpan setelah app dibuka ulang
- Reset hanya menghapus progress malam ini, bukan daftar reusable item
- Layout tetap rapi di layar iPhone kecil dan besar
- Navigation, sheets, form controls, dan destructive actions terasa native sesuai Apple HIG
- Teks tetap terbaca dengan kontras yang baik
- State penting tidak hanya dibedakan lewat warna

## Nice-to-have after MVP

- Haptic feedback saat checklist dicentang
- Quick presets untuk breakfast
- Visual summary saat semua selesai
- Lightweight onboarding card di first launch
