# IronClaw Flutter Integration Research Report

This report outlines the strategy for embedding the IronClaw Rust core into a cross-platform Flutter application using `flutter_rust_bridge` (FRB) v2.

## 1. Architectural Overview

The integration will follow a "Core-Bridge-UI" pattern:

- **Core (Rust):** The existing `ironclaw` crate, used as a library.
- **Bridge (Rust + FRB):** A new `ironclaw_flutter` crate that exposes the Agent's capabilities via FRB-generated bindings.
- **UI (Flutter):** A modern chat application that communicates with the bridge via asynchronous streams.

### Structure Diagram

```text
┌──────────────────────────┐
│       Flutter UI         │ (Dart)
└───────────┬──────────────┘
            │ (Async Calls / Streams)
┌───────────▼──────────────┐
│  flutter_rust_bridge     │ (Generated Glue)
└───────────┬──────────────┘
            │
┌───────────▼──────────────┐
│   ironclaw_flutter       │ (Rust Bridge Crate)
│ ┌──────────────────────┐ │
│ │   Agent Handle       │ │
│ └──────────┬───────────┘ │
└────────────┼─────────────┘
            │
┌────────────▼─────────────┐
│      ironclaw core       │ (Rust Library)
│ ┌────────┐  ┌──────────┐ │
│ │ Agent  │  │ AppBuild │ │
│ └────────┘  └──────────┘ │
└──────────────────────────┘
```

## 2. Core Components to Reuse

IronClaw's modular design allows for high reuse of existing components:

- **AppBuilder & AppComponents:** The primary initialization engine. It handles database setup, secret injection, LLM provider chain construction, and tool registration.
- **Agent Execution Loop:** The core reasoning and tool-execution loop.
- **LibSQL Database:** The `libsql` feature provides an embedded SQLite-compatible backend, perfect for mobile (iOS/Android) and desktop storage.
- **LLM Provider Chain:** All retry logic, smart routing, and failover work out-of-the-box.
- **Tool Registry:** Both builtin and MCP/WASM tools can be supported, though WASM may require specific configuration on mobile.

## 3. The Bridge Layer (ironclaw_flutter)

The bridge crate will be responsible for:

### 1. Handle Management
Wrapping the `Agent` and `AppComponents` in a thread-safe handle (e.g., `Arc<Mutex<AgentHandle>>`) to persist state across the bridge.

### 2. Initialization API
```rust
pub async fn init_agent(config_data: ConfigData, app_dir: String) -> Result<AgentHandle> {
    // 1. Setup paths (DB, logs, tools) using app_dir from Flutter
    // 2. Build AppComponents via AppBuilder
    // 3. Initialize Agent
    // 4. Return handle
}
```

### 3. Streaming Events
Using FRB v2's `StreamSink` to push real-time updates to Flutter:
- `MessageChunk`: For streaming LLM responses.
- `ToolCall`: To show which tool is currently running.
- `StatusUpdate`: For system-level logs and heartbeat status.

## 4. Platform-Specific Considerations

### Database (LibSQL)
- On mobile, the database file must reside in the application's documents directory.
- `flutter_rust_bridge` will pass these paths from Dart to Rust during initialization.

### Secrets & Security
- **Native Keychains:** IronClaw already supports macOS Keychain and Linux Secret Service.
- **Mobile Support:** We may need to implement a `SecretsStore` adapter that calls back into Dart to use `flutter_secure_storage` for iOS/Android, or extend the Rust side to support iOS Keychain and Android Keystore.

### WASM Sandbox (Wasmtime)
- **Challenge:** `wasmtime` (JIT) is restricted on iOS and some Android configurations.
- **Solution:** 
  1. Use Wasmtime's interpreter mode (slower but compliant).
  2. Or, disable WASM tools on mobile while keeping them for Desktop.
  3. Or, run critical WASM tools as "Builtin" tools compiled directly into the binary.

### Network
- `reqwest` with `rustls` is generally cross-platform compatible.

## 5. Integration Plan

### Phase 1: Bridge Prototyping
1. Create `ironclaw_flutter` crate.
2. Define a minimal `init` and `chat` API.
3. Verify `libsql` works on a target platform (e.g., macOS/Simulator).

### Phase 2: Core Adapter
1. Implement a `FlutterChannel` in `ironclaw` core to handle bidirectional communication over the bridge.
2. Map IronClaw's `OutgoingResponse` and `StatusUpdate` to FRB-compatible structs.

### Phase 3: Flutter UI Development
1. Build a responsive Chat UI.
2. Implement a "Provider" or "Bloc" that manages the Rust handle.
3. Add a "Developer Console" to view the agent's internal reasoning and logs (using `LogBroadcaster`).

## 6. Structure Recommendations

- **Crate Split:** Keep the bridge in a separate crate to avoid bloating the core `ironclaw` crate with FRB dependencies.
- **Feature Flags:** Use feature flags to selectively disable heavy components (like Docker/Sandbox) on mobile platforms where they are unavailable.
- **Async Everywhere:** Leverage IronClaw's existing `tokio` integration, as FRB v2 handles async Rust seamlessly.
