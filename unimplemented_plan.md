# AInterview Unimplemented Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Merangkum fitur AInterview yang belum lengkap diimplementasikan dan menyusun rencana kerja untuk menyelesaikan gap utama.

**Architecture:** Fitur yang belum selesai perlu dipisah menjadi tiga area: persistence/auth untuk Interview Plan, metadata dan riwayat Interview Session, serta koneksi hasil Review ke jadwal latihan aktif. Implementasi sebaiknya tetap mengikuti struktur project sekarang: `lib/models`, `lib/services`, `lib/providers`, dan `lib/screens`.

**Tech Stack:** Flutter, Dart, ChangeNotifier, OpenRouter API, Firebase Auth, Cloud Firestore, speech-to-text, text-to-speech.

---

## Status Singkat Saat Ini

Yang sudah tersedia di kode:

- Model dasar interview plan, schedule item, enum level/language/stage.
- Rule-based schedule generator.
- Controller CRUD plan berbasis repository.
- Repository in-memory untuk development/test.
- UI dasar Interview Plan.
- UI interview teks dengan pilihan level, stage HR/Technical, dan language.
- OpenRouter AI service dengan fallback model.
- Review dasar setelah `End Interview & Get Review`.

Yang belum lengkap:

- Plan belum tersimpan permanen di Firestore.
- App belum memakai Firebase Auth untuk user asli.
- UI plan masih berorientasi satu plan pertama, bukan daftar plan aktif.
- Level interview dan tipe interview belum menjadi metadata riwayat sesi/review yang bisa disimpan, difilter, atau dikaitkan ke plan.
- Rekomendasi review belum bisa otomatis atau semi-otomatis ditambahkan ke Interview Plan aktif.
- Voice input dan voice response belum tersedia.
- Review belum disimpan sebagai riwayat di Profile.
- Test suite perlu distabilkan karena `flutter test` sempat timeout.

---

## Gap 1: Firebase Auth dan Firestore Persistence

### Masalah

`InterviewPlanRepository` sudah punya interface, tetapi implementasi runtime masih memakai `InMemoryInterviewPlanRepository`. App juga memakai `userId: 'demo_user'`, sehingga plan hilang setelah app restart dan belum sesuai requirement `users/{userId}/plans`.

### Target Implementasi

- Tambahkan Firebase initialization.
- Ambil user id dari Firebase Auth.
- Buat repository Firestore untuk path `users/{userId}/plans`.
- Tetap pertahankan in-memory repository untuk unit test.

### File Terkait

- Modify: `pubspec.yaml`
- Modify: `lib/main.dart`
- Modify: `lib/services/interview_plan_repository.dart`
- Test: `test/interview_plan_controller_test.dart`
- Add test: `test/firestore_interview_plan_repository_test.dart` jika memakai fake/mock Firestore.

### Rencana

- [ ] Tambahkan dependencies `firebase_core`, `firebase_auth`, dan `cloud_firestore`.
- [ ] Jalankan `flutterfire configure` untuk membuat konfigurasi Firebase per platform.
- [ ] Buat `FirestoreInterviewPlanRepository implements InterviewPlanRepository`.
- [ ] Simpan `InterviewPlan.toMap()` ke `users/{userId}/plans/{planId}`.
- [ ] Baca data dengan ordering `targetDate`.
- [ ] Ganti `demo_user` dengan current authenticated user.
- [ ] Tambahkan fallback UI jika user belum login.
- [ ] Jalankan `flutter analyze`.
- [ ] Jalankan test repository/controller.

---

## Gap 2: Load Plan Saat App Dibuka

### Masalah

`InterviewPlanController.loadPlans()` sudah ada, tetapi app belum memanggilnya saat screen/controller dibuat. Setelah persistence tersedia, data existing harus langsung dimuat.

### Target Implementasi

- Plan tersimpan dapat muncul kembali saat app dibuka.
- Loading dan error state terlihat di UI.

### File Terkait

- Modify: `lib/main.dart`
- Modify: `lib/screens/interview_plan_screen.dart`
- Test: `test/widget_test.dart`
- Test: `test/interview_plan_controller_test.dart`

### Rencana

- [ ] Panggil `_planController.loadPlans()` setelah controller dibuat di `MainNavigationWrapper.initState`.
- [ ] Tampilkan loading state ketika `controller.isLoading == true`.
- [ ] Tampilkan error state ketika `controller.errorMessage != null`.
- [ ] Tambahkan widget test untuk memastikan saved plan muncul setelah `loadPlans()`.

---

## Gap 3: Multi-Plan Management

### Masalah

UI saat ini memakai `plans.first`, sehingga app efektif hanya mengelola satu plan. Requirement menyebut CRUD plan, jadi user perlu bisa melihat daftar plan dan memilih detail plan.

### Target Implementasi

- User bisa punya lebih dari satu Interview Plan.
- User bisa memilih plan aktif.
- Aksi edit/delete/mark completed berjalan pada plan yang dipilih.

### File Terkait

- Modify: `lib/screens/interview_plan_screen.dart`
- Modify: `lib/providers/interview_plan_controller.dart`
- Test: `test/widget_test.dart`
- Test: `test/interview_plan_controller_test.dart`

### Rencana

- [ ] Tambahkan state `selectedPlanId` di `InterviewPlanController`.
- [ ] Tambahkan getter `selectedPlan`.
- [ ] Tampilkan daftar plan dalam bentuk card/list ringkas.
- [ ] Saat card plan dipilih, tampilkan detail timeline plan tersebut.
- [ ] Saat create plan baru berhasil, jadikan plan baru sebagai selected plan.
- [ ] Saat delete selected plan, pindahkan selected plan ke plan terdekat berikutnya.
- [ ] Tambahkan test untuk create dua plan, pilih plan kedua, lalu mark completed hanya pada plan kedua.

---

## Gap 4: Level Per Interview dan Tipe Interview

### Masalah

Level (`Intern`, `Junior Dev`, `Senior Dev`) dan tipe/stage interview (`HR`, `Technical`) sudah bisa dipilih saat memulai sesi, tetapi metadata ini belum menjadi data sesi yang persisted. Akibatnya review dan riwayat interview tidak bisa difilter berdasarkan level dan tipe interview, serta sulit dikaitkan ke schedule plan tertentu.

### Target Implementasi

- Setiap sesi interview memiliki metadata eksplisit:
  - `level`
  - `stage` atau `interviewType`
  - `language`
  - `startedAt`
  - `endedAt`
  - `linkedPlanId`
  - `messages`
  - `review`
- Review selalu tahu sesi itu untuk level dan tipe interview apa.
- Profile atau history bisa menampilkan sesi berdasarkan level dan tipe.

### File Terkait

- Add: `lib/models/interview_session.dart`
- Modify: `lib/models/interview_review.dart`
- Modify: `lib/providers/interview_session_controller.dart`
- Modify: `lib/screens/interview_session_screen.dart`
- Add: `lib/services/interview_session_repository.dart`
- Test: `test/interview_session_controller_test.dart`

### Rencana

- [ ] Buat model `InterviewSession` yang menyimpan metadata sesi dan transcript.
- [ ] Tambahkan field `level`, `stage`, dan `language` ke data review atau bungkus review di `InterviewSession`.
- [ ] Saat user menekan `Start Mock Interview`, buat session draft dengan metadata pilihan user.
- [ ] Saat user menekan `End Interview & Get Review`, isi `endedAt` dan attach `InterviewReview`.
- [ ] Simpan session ke repository setelah review selesai.
- [ ] Tambahkan filter history berdasarkan `level` dan `stage`.
- [ ] Tambahkan test bahwa sesi `Senior Dev Technical` menghasilkan review dengan metadata `senior` dan `technical`.

---

## Gap 5: Keterkaitan Rekomendasi Review dengan Interview Plan

### Masalah

Pada saat evaluasi selesai (`End Interview & Get Review`), rekomendasi belajar yang dihasilkan oleh AI belum bisa dihubungkan atau ditambahkan secara otomatis ke dalam jadwal latihan aktif milik user di menu Plan. Saat ini rekomendasi hanya tampil sebagai teks di panel review.

### Target Implementasi

- Review menghasilkan rekomendasi yang bisa diubah menjadi schedule item.
- User bisa menambahkan rekomendasi ke plan aktif.
- App menyimpan relasi antara review, rekomendasi, dan plan/schedule item.
- Flow tetap aman: user dapat memilih rekomendasi mana yang ingin dimasukkan ke plan.

### Desain Data

Tambahkan model rekomendasi yang lebih terstruktur:

```dart
class ReviewRecommendation {
  const ReviewRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.stage,
    this.linkedPlanId,
    this.linkedScheduleItemIndex,
  });

  final String id;
  final String title;
  final String description;
  final InterviewLevel level;
  final InterviewStage stage;
  final String? linkedPlanId;
  final int? linkedScheduleItemIndex;
}
```

Tambahkan metadata opsional pada `ScheduleItem`:

```dart
class ScheduleItem {
  const ScheduleItem({
    required this.dayOffset,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.sourceReviewId,
    this.sourceRecommendationId,
  });

  final int dayOffset;
  final String title;
  final String description;
  final bool isCompleted;
  final String? sourceReviewId;
  final String? sourceRecommendationId;
}
```

### File Terkait

- Modify: `lib/models/schedule_item.dart`
- Modify: `lib/models/interview_review.dart`
- Modify: `lib/services/open_router_ai_interview_service.dart`
- Modify: `lib/services/ai_interview_service.dart`
- Modify: `lib/providers/interview_plan_controller.dart`
- Modify: `lib/providers/interview_session_controller.dart`
- Modify: `lib/screens/interview_session_screen.dart`
- Modify: `lib/screens/interview_plan_screen.dart`
- Test: `test/interview_session_controller_test.dart`
- Test: `test/interview_plan_controller_test.dart`
- Test: `test/widget_test.dart`

### Rencana

- [ ] Ubah review prompt agar AI mengembalikan rekomendasi berbentuk object: `title`, `description`, `level`, dan `stage`.
- [ ] Parse rekomendasi object di `OpenRouterAiInterviewService`.
- [ ] Update `MockAiInterviewService` agar menghasilkan rekomendasi terstruktur untuk test.
- [ ] Tambahkan method `appendReviewRecommendations()` di `InterviewPlanController`.
- [ ] Method tersebut menerima `planId`, `reviewId`, dan daftar rekomendasi terpilih.
- [ ] Convert setiap rekomendasi menjadi `ScheduleItem` dengan `dayOffset` setelah item terakhir plan aktif.
- [ ] Tampilkan tombol `Add to Active Plan` pada panel review.
- [ ] Jika belum ada plan aktif, tampilkan aksi `Create Plan from Review`.
- [ ] Setelah rekomendasi ditambahkan, tampilkan status linked di review.
- [ ] Tambahkan test bahwa rekomendasi review `State Management` bisa masuk ke schedule plan aktif.

---

## Gap 6: Voice Input dan Voice Response

### Masalah

Voice belum tersedia. Belum ada dependency speech-to-text, text-to-speech, microphone permission, status listening, processing, dan speaking.

### Target Implementasi

- User bisa menjawab interview dengan suara.
- AI response bisa dibacakan.
- Text input tetap tersedia sebagai fallback.

### File Terkait

- Modify: `pubspec.yaml`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `ios/Runner/Info.plist`
- Modify: `lib/providers/interview_session_controller.dart`
- Modify: `lib/screens/interview_session_screen.dart`
- Add: `lib/services/interview_voice_service.dart`
- Test: `test/interview_session_controller_test.dart`

### Rencana

- [ ] Tambahkan dependency `speech_to_text`, `flutter_tts`, dan `permission_handler`.
- [ ] Tambahkan permission microphone Android dan iOS.
- [ ] Buat service wrapper agar STT/TTS mudah di-mock saat test.
- [ ] Tambahkan state `isListening`, `isSpeaking`, dan `voiceErrorMessage`.
- [ ] Tambahkan tombol push-to-talk di interview session.
- [ ] Masukkan hasil STT ke text field sebelum dikirim.
- [ ] Bacakan AI response setelah message AI diterima jika voice toggle aktif.
- [ ] Tambahkan fallback text input saat permission ditolak.

---

## Gap 7: Saved Reviews dan Profile

### Masalah

Tab Profile masih placeholder. Review hanya muncul setelah sesi selesai dan belum tersimpan sebagai riwayat.

### Target Implementasi

- User bisa melihat review lama.
- Review bisa difilter berdasarkan level, tipe interview, tanggal, dan plan terkait.
- Review bisa membuka plan yang pernah menerima rekomendasi dari review tersebut.

### File Terkait

- Modify: `lib/main.dart`
- Add: `lib/screens/profile_screen.dart`
- Add: `lib/services/interview_session_repository.dart`
- Modify: `lib/providers/interview_session_controller.dart`
- Test: `test/widget_test.dart`

### Rencana

- [ ] Buat repository session/review untuk `users/{userId}/interview_sessions`.
- [ ] Simpan review setelah `End Interview & Get Review`.
- [ ] Ganti placeholder Profile dengan `ProfileScreen`.
- [ ] Tampilkan list review dengan badge level dan stage.
- [ ] Tambahkan filter level dan stage.
- [ ] Tambahkan detail review berisi summary, feedback, improvement areas, recommendations, dan linked plan.

---

## Gap 8: Verification dan Stabilization

### Masalah

`flutter analyze` berjalan dan hanya menemukan info lint/deprecated, tetapi `flutter test` sempat timeout. Test suite perlu distabilkan sebelum fitur berikutnya dianggap aman.

### Target Implementasi

- Test suite bisa selesai deterministik.
- Unit test menutup logic repository, controller, AI parsing, review linking, dan voice wrapper.
- Widget test menutup flow utama.

### File Terkait

- Modify: `test/widget_test.dart`
- Modify: `test/interview_plan_controller_test.dart`
- Modify: `test/interview_session_controller_test.dart`
- Modify: `test/open_router_ai_interview_service_test.dart`

### Rencana

- [ ] Jalankan `flutter test -r expanded` dan catat file yang macet.
- [ ] Jalankan setiap file test secara terpisah.
- [ ] Pastikan semua async operation di widget test memakai fake service yang langsung selesai.
- [ ] Pastikan controller/service tidak membuat client network nyata saat test.
- [ ] Tambahkan fake repository dan fake voice service.
- [ ] Jalankan `flutter analyze`.
- [ ] Jalankan `flutter test`.

---

## Urutan Prioritas Implementasi

1. Stabilkan test suite.
2. Implementasikan metadata level dan tipe interview per session.
3. Implementasikan saved review/history.
4. Implementasikan koneksi rekomendasi review ke Interview Plan aktif.
5. Implementasikan Firestore repository dan Auth.
6. Implementasikan multi-plan UI.
7. Implementasikan voice input/output.
8. Lakukan regression pass untuk semua flow utama.

---

## Acceptance Criteria Akhir

- User login memiliki plan di `users/{userId}/plans`.
- Plan tetap muncul setelah app restart.
- User bisa punya dan memilih lebih dari satu plan.
- Setiap interview session tersimpan dengan level, stage/type, language, transcript, review, dan linked plan.
- Review `Senior Dev Technical` bisa dibedakan dari review `Junior Dev HR`.
- Rekomendasi review bisa ditambahkan ke active plan sebagai schedule item baru.
- Schedule item dari review menyimpan sumber `reviewId` dan `recommendationId`.
- Profile menampilkan saved reviews.
- Voice input/output berjalan dengan fallback text.
- `flutter analyze` selesai tanpa error.
- `flutter test` selesai tanpa timeout.
