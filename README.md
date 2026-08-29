[README.md](https://github.com/user-attachments/files/31580226/README.md)
<!--
1. Replace every placeholder in [SQUARE_BRACKETS].
2. Keep sections marked "Required" unless the competition rules say otherwise.
3. Delete these instructional comments from the final README.
4. Place images in docs/images/, or use GitHub user-content URLs instead. Feel free to choose.
-->

<div align="center">

  <!--
  Required:
  - Export one high-resolution, app logo file as png.
  - Save it as docs/images/app-logo.png, or update the path below.
  - Compress the image before adding it to the repository for better experience :)
  -->
  <img src="docs/images/app-logo.png" alt="Duory logo" width="180" />

  <!--
  Required:
  - Export one high-resolution, wide mockup that presents the main application screens.
  - Save it as docs/images/app-mockup.png, or update the path below.
  - Recommended width: at least 1600 px.
  - Compress the image before adding it to the repository.
  -->
  <p align="center">
    <img src="docs/images/app-mockup.png" alt="Duory mockup" width="100%" />
  </p>

  # Duory

  **[Aplikasi couple companion yang bantu pasangan sibuk tetap terhubung dengan lewat kuis harian yang seru buat dimainkan kapan aja, dan ruang khusus buat nyimpen cerita kecil yang belum sempat dibahas.
]**

  <br />

  <!-- Keep only badges that are relevant to your project. -->
  ![Platform](https://img.shields.io/badge/Platform-[PLATFORM]-4A90E2?style=for-the-badge)
  ![Platform](https://img.shields.io/badge/Platform-[PLATFORM]-4A90E2?style=for-the-badge)
  ![Platform](https://img.shields.io/badge/Platform-[PLATFORM]-4A90E2?style=for-the-badge)
  ![Platform](https://img.shields.io/badge/Platform-[PLATFORM]-4A90E2?style=for-the-badge)

</div>

---

<!-- [!IMPORTANT]
Replace every item in square brackets before submission. Never put private API keys, personal accounts, signing files, or production credentials in this repository. -->

## Table of contents

- [Project overview](#project-overview)
- [Key features](#key-features)
- [Technology stack](#technology-stack)
- [Project structure](#project-structure)
- [Team](#team)

## Project overview

<!-- Required. Keep the table short and factual. -->

| Item | Details |
| --- | --- |
| Application Type | Mobile
| Primary Platform | Android

Duory adalah aplikasi pendamping pasangan yang ditujukan untuk pasangan usia dewasa muda yang memiliki kesibukan kuliah atau kerja, termasuk pasangan LDR. Aplikasi ini membantu pasangan tetap terhubung melalui kuis harian yang dapat dikerjakan secara asinkron dan ruang untuk menyimpan cerita atau topik kecil yang belum sempat dibicarakan. Masalah ini penting karena kesibukan masing-masing sering membuat interaksi ringan berkurang dan hal-hal kecil yang ingin diceritakan akhirnya terlupakan.

## Key features

<!-- Required. List only features that users can find in the submitted build. -->

| Feature | What the user can do |
| --- | --- |
| [AUTHENTICATION] | [Memastikan hanya user yang terdaftar yang bisa mengakses akun dan cerita/momen miliknya dan pasangannya.] |
| [QUIZ] | [Memicu interaksi harian ringan (daily routine loop) tanpa beban dan menciptakan momen penasaran yang mendorong pasangan saling terhubung di tengah kesibukan.] |
| [CHAT | [Memberi tempat lanjutan untuk merespons momen-momen kecil (hasil quiz, topik yang dibuka) dengan effort rendah, sekaligus menyimpan jejak momen berdua sebagai timeline yang bisa di-flashback.] |
| [AVAIBILITY] | [Menghilangkan rasa bersalah/ketakutan mengganggu pasangan yang sedang sibuk, serta membantu pasangan menemukan momen waktu luang bersama tanpa harus bertanya "Lagi sibuk gak?" secara terus-menerus.] |
| [TOPIC INBOX] | [Memastikan momen-momen kecil sehari-hari gak hilang/lupa gara-gara kesibukan, dan jadi pengingat bersama yang menyenangkan (bukan kayak to-do list) soal topik apa yang mau diobrolin pasangan berikutnya.
] |


## Technology stack

<!-- Required. Include only technology used by the submitted project. You can add as many as you want based on your project -->

| Category | Technology | Purpose |
| --- | --- | --- |
| Frontend | [Flutter dan Dart] | [Lebih update dan modern dari segi struktur] |
| Architecture | [ MVVM ] | [Memisahkan UI, state management, dan business logic] |
| State Management | [Provider ] | [Mengelola state dan menghubungkan UI dengan ViewModel] |
| Backend | [Supabase ] | [Menyediakan backend services dan komunikasi dengan database] |
| Database | [PostgreSQL ] | [Menyimpan data pengguna, profil, pasangan, pesan, dan kuis ] |
| Authentication | [Supabase Auth] | [Mengelola autentikasi dan session pengguna] |
| Realtime | Supabase Realtime | Mendukung pembaruan data chat dan koneksi pasangan secara realtime |
| Storage | Supabase Storage | Menyimpan dan mengelola foto profil |
| External API | Google Sign-In | Menyediakan autentikasi menggunakan akun Google |

## Project structure

<!-- Required. Adapt this example to the repository. Not fixed like this, you can modify it based on your project -->

```text

├── lib/
│   ├── core/          # App theme and shared configurations
│   ├── models/        # Application data models
│   ├── screens/       # UI screens and widgets
│   ├── services/      # Backend and external services
│   ├── viewmodels/    # State management and business logic
│   └── main.dart      # Application entry point
├── assets/            # Images and static assets
└── pubspec.yaml       # Project configuration and dependencies

<!--
Required. Feel free to modify this part based on your Tech Stack. This is example if you're using Flutter
-->
## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK installed on your machine.
*   An editor like VS Code or Android Studio.

### Installation

1.  **Clone the repo**
    ```sh
    git clone https://github.com/[PROFILE]/[REPOSITORY].git
    ```
2.  **Navigate to the project directory**
    ```sh
    cd [DIRECTORY]
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Run the app**
    ```sh
    flutter run
    ```

---

## Team

<!-- Required. Add or remove rows to match the team. -->

| Name | Role | Responsibilities | Contact |
| --- | --- | --- | --- |
| [FULL_NAME] | Product Manager | [Main responsibilities] | [GitHub / LinkedIn] |
| [FULL_NAME] | UI/UX Designer | [Main responsibilities] | [GitHub / LinkedIn] |
| [FULL_NAME] | Mobile Engineer | [Main responsibilities] | [GitHub / LinkedIn] |
