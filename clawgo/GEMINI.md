# IronClaw / CyberClaw Project Overview

IronClaw is a secure, personal AI assistant designed with a focus on local data privacy, transparency, and extensibility. **CyberClaw** is the project's cross-platform Flutter-based control application, providing a sophisticated "cyberpunk" terminal interface for interacting with the IronClaw Rust core.

## Project Structure

This directory (`clawgo/`) contains the frontend and design assets for the IronClaw ecosystem.

- **`cyberclaw/`**: The primary Flutter application.
  - **`lib/`**: Dart source code following a presentation/core architecture.
  - **`rust/`**: Rust bridge code using `flutter_rust_bridge` (FRB) v2 to interface with the IronClaw core.
  - **`rust_builder/`**: Build utility for the Rust-to-Dart bridge.
- **`design/`**: UI/UX design specifications and assets.
  - **`v1/`**: Screen-specific design iterations (e.g., Chat Console, Auth, Settings).
  - **`flutter_integration.md`**: Architectural report detailing the "Core-Bridge-UI" integration strategy.

## Tech Stack

### Frontend (CyberClaw)
- **Framework**: Flutter (Dart)
- **Navigation**: `go_router`
- **Authentication**: Firebase Auth
- **AI Interface**: `flutter_ai_toolkit` (customized with `IronClawChatProvider`)
- **Bridge**: `flutter_rust_bridge` v2 (FRB)
- **Styling**: Highly customized Dark/Cyber theme with beveled edges and grid-pattern backgrounds.
- **Dynamic UI**: Support for `GENUI` (Generated UI) markers in LLM responses to render custom status panels.

### Backend (IronClaw Core - Root Directory)
- **Language**: Rust 1.85+
- **Sandbox**: WASM (Wasmtime) for secure tool execution.
- **Database**: PostgreSQL with `pgvector` for long-term memory; `libsql` for local embedded storage.
- **Orchestration**: Docker-based sandboxing for high-privilege tasks.

## Key Commands

### CyberClaw (Flutter App)
Run these commands within the `cyberclaw/` directory:

- **Environment Setup**: `flutter pub get`
- **Run Application**: `flutter run` (Supports macOS, iOS, Android, and Web)
- **Generate Bridge Bindings**: `flutter_rust_bridge_codegen generate`
- **Build Production**: `flutter build <platform>`
- **Deploy to Firebase App Distribution (Android)**:
  1. Increment version and build number in `pubspec.yaml`.
  2. Build APK: `flutter build apk --release`.
  3. Deploy: `firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app <ANDROID_APP_ID> --groups <TESTER_GROUPS> --release-notes "<RELEASE_NOTES>"` (Get App ID from `lib/firebase_options.dart`).

### IronClaw (Core - Root Directory)
Run these commands from the project root:

- **Build Core**: `cargo build --release`
- **Run Tests**: `cargo test`
- **Initial Setup**: `ironclaw onboard` (Runs the interactive configuration wizard)
- **Full Build**: `./scripts/build-all.sh` (Rebuilds WASM channels and core binary)

## Development Conventions

1.  **UI/UX Aesthetic**: Strictly adhere to the "IRONCLAW CONTROL" visual language:
    - Primary Color: Cyan/Primary (High visibility)
    - Surface: Deep black/surface (Low-lit terminal feel)
    - Components: Use `BeveledEdgeClipper` for cards and buttons; utilize grid patterns for background depth.
2.  **State Management**: The app uses `ChangeNotifier` and `Provider` patterns. The `IronClawChatProvider` is the central hub for LLM communication.
3.  **Bridge Pattern**: New Rust capabilities should be exposed via `cyberclaw/rust/src/api/` and re-generated using the FRB codegen tool.
4.  **Auth Flow**: Navigation is guarded by `AuthService`. Ensure all protected routes (like `/chat`) are checked in `router.dart`.
5.  **GenUI**: When implementing new agent capabilities, consider using the `[GENUI:{"type":"...", ...}]` JSON marker in responses to trigger rich UI components in the chat.

## Usage & Integration

The Flutter app currently uses a mock `IronClawChatProvider` for UI prototyping. Integrating the real Rust `Agent` handle via the `RustLib` bridge is a priority. Refer to `design/flutter_integration.md` for the planned architectural mapping.
