# Morning Prep Assistant

## App concept

Morning Prep Assistant adalah aplikasi iOS sederhana untuk membantu pelajar, peserta kursus, dan young professionals menyiapkan kebutuhan besok malam sebelumnya. Fokus utama aplikasi ini adalah mengurangi stres pagi hari dengan satu alur singkat: cek barang, tentukan outfit, rencanakan sarapan, lalu tambahkan catatan penting.

Nilai utama produk:
- Mengurangi kemungkinan barang tertinggal
- Membuat persiapan malam terasa ringan dan cepat
- Memberi rasa tenang sebelum tidur
- Menjaga scope tetap realistis untuk MVP 2 hari

## Core UX idea

Satu layar utama menjadi pusat persiapan besok. User tidak perlu berpindah-pindah screen untuk tugas utama. Aplikasi menampilkan status kesiapan secara jelas dan memberi dorongan kecil sampai status berubah menjadi "Ready for Tomorrow".

Prinsip UX:
- Selesai dalam kurang dari 3 menit
- Fokus pada kejelasan, bukan banyak fitur
- Input cepat, tidak melelahkan sebelum tidur
- Visual tenang, hangat, dan iOS-native
- Wajib mengikuti Apple Human Interface Guidelines agar terasa benar-benar native di iPhone

## Target user

- Morning learner apple developer academy

## User flow

### Primary flow
1. User membuka app malam hari
2. User melihat readiness status untuk besok
3. User centang item yang sudah disiapkan
4. User pilih atau tulis outfit
5. User pilih atau tulis rencana sarapan
6. User tambah note jika ada hal penting
7. User set reminder malam bila belum aktif
8. Status berubah menjadi "Almost Ready" atau "Ready for Tomorrow"

### Secondary flow
1. User membuka Settings/Edit
2. User menambah atau menghapus reusable items
3. User mengubah reminder time
4. User reset persiapan untuk hari berikutnya

## Screen structure

### 1. Home / Tomorrow Prep
Tujuan:
- Menjadi layar utama untuk semua aktivitas inti

Konten:
- Simple greeting: "Prep for Tomorrow"
- Readiness card
- Checklist section: "What to Bring"
- Outfit section: "What to Wear"
- Breakfast section: "Breakfast Plan"
- Notes section: "Important Notes"
- Reminder CTA: "Nightly Reminder"
- Primary action opsional: "Mark Tonight Complete"

Komponen:
- Progress ring atau progress bar
- Checklist rows dengan reusable items
- Quick input chips atau single-line text field
- Calm status card dengan copy singkat

### 2. Edit / Settings
Tujuan:
- Mengelola item reusable dan pengaturan ringan

Konten:
- Reusable items list
- Add item field
- Reminder time picker
- Toggle notification on/off
- Reset for tomorrow button

Komponen:
- List editor sederhana
- Native iOS time picker
- Destructive reset button yang tetap clean

## Readiness status logic

Gunakan logic sederhana agar mudah dibangun:

- `Not Ready`
  - Kurang dari 40% item inti selesai
- `Almost Ready`
  - 40% sampai 89% selesai
- `Ready for Tomorrow`
  - Semua bagian inti selesai atau minimal 90% selesai

Item inti MVP:
- Minimal 1 item checklist diperiksa
- Outfit terisi
- Breakfast terisi

Optional:
- Notes tidak wajib untuk status Ready

## UI suggestions

### Visual tone
- Calm
- Minimal
- Soft productivity
- Friendly, tidak terlalu playful

### Layout
- Gunakan `NavigationStack`
- Home memakai `ScrollView` dengan card sections
- Spacing lega, 16-24pt
- Section titles singkat dan jelas

### Components
- Rounded cards dengan radius 20-24
- Soft shadow tipis
- Checklist row dengan checkbox bulat
- Progress card di atas fold
- Bottom sheet atau sheet sederhana untuk edit item

### Suggested iOS patterns
- `List` untuk settings editor
- `Form` hanya jika memang lebih cepat, tapi hindari feel terlalu padat
- `sheet` untuk tambah item atau edit reminder
- `@AppStorage` untuk simpan state ringan
- `UserNotifications` untuk local reminder

## Apple Human Interface Guidelines emphasis

Desain Morning Prep Assistant harus secara eksplisit mengikuti Apple Human Interface Guidelines, bukan hanya terlihat "mirip iOS". Ini penting supaya aplikasi terasa natural, mudah dipahami, dan sesuai ekspektasi user iPhone.

Prinsip yang harus dijaga:
- Gunakan komponen native SwiftUI sebisa mungkin
- Hormati safe area, ukuran tap target, dan keterbacaan teks
- Prioritaskan hierarchy visual yang jelas daripada dekorasi berlebihan
- Gunakan pola navigasi iOS yang familiar dan ringan
- Pastikan semua kontrol terlihat interaktif dan statusnya mudah dipahami
- Hindari custom UI yang mengorbankan usability hanya demi tampil unik
- Gunakan motion yang subtle dan purposeful
- Pastikan warna, kontras, dan spacing mendukung aksesibilitas dasar

Aturan praktis untuk implementasi:
- Pakai `NavigationStack`, `sheet`, `DatePicker`, `Toggle`, `TextField`, `TextEditor`, dan `List` sesuai perilaku native
- Jangan membuat gesture atau pola interaksi yang tidak umum di iOS jika tidak benar-benar perlu
- Pastikan destructive actions seperti reset diberi konfirmasi
- Gunakan SF Symbols agar bahasa visual konsisten dengan sistem
- Jaga copy tetap singkat, jelas, dan actionable
- Pastikan darkened overlays, shadow, dan accent tidak mengganggu legibility
- Jika ada elemen custom card, perilakunya tetap harus terasa seperti extension dari iOS, bukan UI yang asing

## Clean iOS-style design direction

### Color direction
- Background: warm off-white atau soft gray
- Primary: muted blue-green atau sage
- Accent: warm yellow lembut untuk highlight readiness
- Success: soft green untuk status siap
- Danger: coral lembut untuk reset/delete

Contoh palette:
- Background: `#F6F4EF`
- Surface: `#FFFDF8`
- Primary text: `#1F2A2E`
- Secondary text: `#6C7A80`
- Accent: `#7FA68C`
- Highlight: `#E8D9A8`

### Typography
- Gunakan SF Pro default iOS
- Title besar, bersih, tidak terlalu berat
- Body copy singkat
- Hindari terlalu banyak ukuran font
- Gunakan semantic text styles bila memungkinkan agar selaras dengan Dynamic Type

### Motion
- Progress berubah dengan animasi halus
- Checkbox dan status card menggunakan spring ringan
- Hindari motion berlebihan
- Hormati prinsip reduced motion; animasi tidak boleh menjadi syarat memahami state

### Iconography
- SF Symbols
- Contoh: `checkmark.circle`, `moon.stars`, `bell`, `tshirt`, `fork.knife`, `note.text`, `backpack`

## MVP scope

### Harus ada
- Home screen dengan semua section inti
- Checklist reusable items
- Mark item complete/incomplete
- Outfit text input
- Breakfast text input
- Notes text input
- Readiness status otomatis
- Reminder settings sederhana
- Data persistence lokal

### Boleh jika sempat
- Quick preset breakfast chips
- Outfit suggestions preset
- Empty state illustration ringan
- Haptic feedback untuk checklist

### Jangan masuk MVP
- Login
- Cloud sync
- AI recommendation
- Calendar integration
- Analytics kompleks
- Multi-user atau social

## Feature prioritization

### P0
- Checklist reusable items
- Readiness status
- Outfit input
- Breakfast input
- Reminder local notification
- Persistence lokal

### P1
- Important notes
- Edit reusable item screen
- Reset for tomorrow

### P2
- Polishing UI
- Empty states lebih kaya
- Preset options

## Empty states and microcopy

### First open
- Title: `Get ready tonight`
- Body: `Set up a few things now so tomorrow feels lighter.`
- CTA: `Start Preparing`

### No checklist items
- Title: `Nothing added yet`
- Body: `Add a few everyday essentials like your charger, bottle, or ID card.`
- CTA: `Add Item`

### Outfit empty
- Placeholder: `School uniform, black hoodie, sneakers...`

### Breakfast empty
- Placeholder: `Overnight oats, toast, banana...`

### Notes empty
- Placeholder: `Bring assignment, leave by 6:30, refill bottle...`

### Reminder off
- Title: `Night reminder is off`
- Body: `A gentle nudge at night can help you stay consistent.`
- CTA: `Set Reminder`

### Ready state
- Title: `Ready for Tomorrow`
- Body: `Everything important is already lined up.`

### Almost ready state
- Title: `Almost Ready`
- Body: `Just one or two things left before tomorrow starts smoothly.`

### Not ready state
- Title: `Not Ready Yet`
- Body: `Take two minutes tonight and make tomorrow easier.`

### Reset confirmation
- Title: `Reset for tomorrow?`
- Body: `This clears tonight's progress but keeps your saved everyday items.`
- Actions: `Reset`, `Cancel`

## Suggested data model

```swift
struct PrepItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isChecked: Bool
    var isDefault: Bool
}

struct TomorrowPrep: Codable {
    var items: [PrepItem]
    var outfit: String
    var breakfast: String
    var notes: String
    var reminderEnabled: Bool
    var reminderTime: Date
}
```

## Suggested SwiftUI structure

- `ContentView`
  - container untuk home screen
- `PrepHomeView`
  - readiness card + semua section
- `ReadinessCardView`
  - status dan progress
- `ChecklistSectionView`
  - reusable items
- `QuickPlanSectionView`
  - outfit, breakfast, notes
- `SettingsView`
  - edit items + reminder
- `PrepStore`
  - observable state + persistence
- `NotificationManager`
  - local notifications

## Step by step pengerjaan

### Step 1. Define MVP and app structure
- Tetapkan hanya 2 screen: Home dan Settings/Edit
- Tentukan model data lokal untuk item, outfit, breakfast, notes, reminder
- Tentukan readiness formula sederhana agar tidak berubah-ubah saat development

Output:
- File model dan store dasar
- Daftar komponen UI yang akan dibuat

### Step 2. Build local state and persistence
- Buat `PrepItem` dan `TomorrowPrep`
- Buat `PrepStore` dengan `ObservableObject`
- Simpan data memakai `UserDefaults` atau `@AppStorage`
- Sediakan default reusable items: charger, bottle, ID card, laptop, notebook

Output:
- State bisa survive app relaunch

### Step 3. Build Home screen
- Buat header sederhana: `Prep for Tomorrow`
- Tambahkan readiness card di bagian atas
- Buat section `What to Bring` dengan checklist interaktif
- Buat section `What to Wear`
- Buat section `Breakfast Plan`
- Buat section `Important Notes`
- Tambahkan tombol atau row untuk `Nightly Reminder`

Output:
- User sudah bisa menyelesaikan flow inti di satu screen

### Step 4. Implement readiness calculation
- Hitung persentase dari item inti dan checklist
- Map hasil ke 3 status: `Not Ready`, `Almost Ready`, `Ready for Tomorrow`
- Tambahkan animasi ringan saat status berubah

Output:
- Progress terasa hidup dan memotivasi

### Step 5. Build Settings/Edit screen
- Buat list reusable items
- Tambahkan kemampuan add item
- Tambahkan delete item
- Tambahkan time picker untuk reminder
- Tambahkan tombol reset untuk besok

Output:
- User bisa personalisasi item hariannya

### Step 6. Add local notification
- Minta izin notifikasi
- Jadwalkan local notification harian
- Copy notifikasi: `Prepare for tomorrow`
- Isi body: `Take a minute to set out what you need for the morning.`

Output:
- Reminder malam aktif sesuai jam pilihan user

### Step 7. Polish UI
- Gunakan warna tenang dan whitespace yang cukup
- Konsistenkan corner radius, padding, dan typography
- Pastikan touch targets nyaman
- Tambahkan state kosong yang jelas dan tidak dingin

Output:
- App terasa lebih matang walau scope kecil

### Step 8. QA and finish
- Test first launch
- Test persistence setelah app ditutup
- Test checklist toggle
- Test reset flow
- Test reminder on/off
- Test tampilan di iPhone ukuran kecil dan besar

Output:
- MVP siap dipresentasikan atau di-demo

## Build plan for 2 days

### Day 1
- Setup data model
- Bangun Home screen
- Implement checklist, text inputs, readiness logic
- Simpan data lokal

### Day 2
- Bangun Settings/Edit
- Tambahkan local notification
- Polish UI
- Isi empty states
- Test dan perbaiki edge cases

## Success criteria

- User bisa menyelesaikan persiapan malam dalam kurang dari 3 menit
- User bisa melihat status kesiapan dengan cepat
- User tidak perlu belajar flow yang kompleks
- App tetap berguna tanpa akun atau internet
