# AInterview Feature Milestones

Dokumen ini menyusun milestone implementasi berdasarkan `plan.md` untuk fitur **AI Interview Plan** dan **AI Interview Chatbot**.

> Catatan batasan:
> - Jangan mengubah file yang sudah ada di `lib/constants` atau `lib/widgets`.
> - Gunakan widget dan design constants yang tersedia sebagaimana adanya.
> - File baru untuk screen, model, provider/state management, service, dan feature logic dibuat di direktori lain seperti `lib/screens`, `lib/models`, `lib/providers`, atau `lib/services`.

## Milestone 1: Fondasi Data dan Struktur Fitur

### Tujuan
Menyiapkan struktur kode dan data model utama agar fitur Interview Plan dan Interview Chatbot punya fondasi yang rapi.

### Deliverable
- Model data untuk interview plan.
- Model data untuk schedule item.
- Enum atau constant baru di luar `lib/constants` untuk level interview, bahasa, dan stage interview jika diperlukan.
- Struktur folder fitur baru untuk plan, chatbot, service, dan provider/state management.

### Kriteria Selesai
- Struktur data sesuai schema Firestore di `plan.md`.
- Tidak ada perubahan pada `lib/constants` dan `lib/widgets`.
- Model dapat digunakan untuk serialize/deserialize data Firestore.

## Milestone 2: Interview Plan CRUD dan Firestore

### Tujuan
Membangun fitur dasar untuk membuat, membaca, mengubah, dan menghapus interview preparation plan.

### Deliverable
- Service Firestore untuk collection `users/{userId}/plans`.
- Provider/state management untuk daftar plan dan detail plan.
- Fungsi create plan dengan input target date, level, dan language.
- Fungsi update plan untuk target date dan level.
- Fungsi delete plan.
- Fungsi mark schedule item as completed.

### Kriteria Selesai
- User yang sudah login dapat menyimpan plan ke subcollection miliknya.
- Plan dapat ditampilkan ulang setelah aplikasi dibuka kembali.
- Update target date atau level memicu recalculation schedule.
- Delete plan menghapus data dari Firestore.

## Milestone 3: Rule-Based Practice Plan Generator

### Tujuan
Menyediakan generator awal untuk timeline persiapan interview sebelum integrasi AI penuh.

### Deliverable
- Generator schedule berdasarkan:
  - Sisa hari menuju target interview date.
  - Level: Intern, Junior Dev, Senior Dev.
  - Language: Indonesian atau English.
- Template task untuk HR dan Technical preparation.
- Penyesuaian topik berdasarkan level.

### Kriteria Selesai
- Plan baru otomatis memiliki `scheduleItems`.
- Intern berisi topik fundamental programming, data structure dasar, OOP, dan mobile platform basics.
- Junior berisi state management, networking/API, database, Git, dan debugging.
- Senior berisi architecture, system design, optimization, testing, security, dan collaboration scenario.

## Milestone 4: UI Interview Plan

### Tujuan
Membangun alur antarmuka untuk mengelola interview preparation plan.

### Deliverable
- Section atau tab Interview Plan di Dashboard/Home.
- Countdown menuju target interview date.
- Progress completion dari schedule item.
- Plan Form Screen dengan date picker, level dropdown, language dropdown, dan tombol generate plan.
- Plan Detail Timeline Screen.
- Aksi edit, delete, dan mark completed.

### Kriteria Selesai
- User dapat menjalankan flow create, view, edit, dan delete dari UI.
- Timeline tampil day-by-day dengan status completion.
- Empty state dan loading state tersedia.
- UI memakai widget/design constants yang sudah ada tanpa mengubah file di `lib/constants` dan `lib/widgets`.

## Milestone 5: AI Interview Chatbot Core

### Tujuan
Membangun sesi interview berbasis chat teks untuk HR dan Technical stage di setiap level.

### Deliverable
- Interview Setup/Lobby Screen.
- Pilihan level: Intern, Junior Dev, Senior Dev.
- Pilihan stage: HR atau Technical.
- Interview Session Screen berbasis chat.
- AI service handler untuk Gemini API atau equivalent.
- System instruction berbeda untuk setiap kombinasi level dan stage.
- Tombol "End Interview & Get Review".

### Kriteria Selesai
- User dapat memulai sesi interview berdasarkan level dan stage.
- AI interviewer menanyakan pertanyaan sesuai konteks level dan stage.
- Chat transcript tampil selama sesi.
- Sesi HR Junior menghasilkan pertanyaan behavioral yang sesuai.
- Sesi Technical Senior menghasilkan pertanyaan lebih kompleks terkait architecture, optimization, testing, dan security.

## Milestone 6: Voice Capabilities

### Tujuan
Menambahkan pengalaman mock interview yang lebih realistis melalui voice input dan voice response.

### Deliverable
- Speech-to-text untuk input jawaban user.
- Text-to-speech untuk response AI interviewer.
- Voice toggle atau push-to-talk button.
- Status microphone di Lobby Screen.
- Fallback ke text input jika voice tidak tersedia.

### Kriteria Selesai
- User dapat mengirim jawaban melalui suara.
- Transcript dari STT masuk ke chat session.
- Response AI dapat dibacakan menggunakan TTS.
- UI menampilkan status listening, processing, dan speaking.

## Milestone 7: Interview Review dan Feedback

### Tujuan
Memberikan ringkasan hasil interview setelah sesi selesai.

### Deliverable
- Review prompt untuk meminta AI mengevaluasi transcript.
- Ringkasan performa user.
- Feedback untuk komunikasi, technical depth, clarity, dan improvement area.
- Rekomendasi latihan berikutnya yang dapat dikaitkan dengan Interview Plan.

### Kriteria Selesai
- Tombol "End Interview & Get Review" menghasilkan feedback.
- Feedback sesuai level dan stage.
- Review dapat digunakan user untuk memperbaiki jadwal latihan berikutnya.

## Milestone 8: Verification dan Stabilization

### Tujuan
Memastikan fitur bekerja stabil secara manual, teknis, dan integrasi AI/voice.

### Deliverable
- Manual test plan untuk Plan Flow.
- Manual test plan untuk AI Chatbot.
- Verifikasi Firestore create, read, update, delete.
- Verifikasi Gemini API/service handler.
- Verifikasi STT dan TTS.
- Perbaikan bug dari hasil testing.

### Kriteria Selesai
- Create, edit, view, mark completed, dan delete plan berhasil.
- Data Firestore sesuai user yang sedang login.
- AI response mengikuti kombinasi level dan stage.
- Voice input/output berjalan atau punya fallback yang jelas.
- Tidak ada perubahan pada direktori terlarang.

## Suggested Implementation Order

1. Milestone 1: Fondasi Data dan Struktur Fitur.
2. Milestone 2: Interview Plan CRUD dan Firestore.
3. Milestone 3: Rule-Based Practice Plan Generator.
4. Milestone 4: UI Interview Plan.
5. Milestone 5: AI Interview Chatbot Core.
6. Milestone 6: Voice Capabilities.
7. Milestone 7: Interview Review dan Feedback.
8. Milestone 8: Verification dan Stabilization.

