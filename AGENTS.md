# Agent Rules

This project is a fork of [ironclaw](https://github.com/nearai/ironclaw).

## Clawgo Effort

The `./clawgo` directory contains an effort to embed the IronClaw Rust core inside a Flutter chat UI application. The goal is to:
- Make IronClaw a cross-platform generic AI agent.
- Use adapters to replace desktop-only components (e.g., Docker sandboxing, certain OS credential stores) with mobile-compliant equivalents for Android and iOS.
- Provide a high-quality, interactive UI as the primary communication channel for the agent.

### Architecture

The integration follows a "Core-Bridge-UI" pattern:
- **Core (Rust):** The existing `ironclaw` crate is used as a library. It reuses highly modular components like `AppBuilder`, the `Agent` execution loop, the `libsql` embedded database, and the LLM Provider Chain.
- **Bridge (Rust + FRB):** A new `ironclaw_flutter` crate exposes the Agent's capabilities via `flutter_rust_bridge` (FRB) v2 bindings. It handles initialization, streaming events (e.g., LLM responses, tool calls, and status updates) via FRB's `StreamSink`, and manages the Agent's thread-safe handle.
- **UI (Flutter):** A modern chat application built in Flutter that communicates with the Rust bridge via asynchronous streams.

### Platform Considerations

- **Database:** Uses the `libsql` feature for a SQLite-compatible backend that works locally on mobile and desktop.
- **WASM Sandbox:** On mobile (due to iOS/Android JIT restrictions for `wasmtime`), WASM tools may fallback to interpreter mode, be disabled entirely, or replaced with critical builtin native tools.
- **Secrets:** Native OS stores (macOS Keychain, Linux Secret Service) are used on desktop. For mobile, a `SecretsStore` adapter interfacing with Dart's `flutter_secure_storage` is planned.

## Feature Parity Update Policy

- If you change implementation status for any feature tracked in `FEATURE_PARITY.md`, update that file in the same branch.
- Do not open a PR that changes feature behavior without checking `FEATURE_PARITY.md` for needed status updates (`❌`, `🚧`, `✅`, notes, and priorities).
