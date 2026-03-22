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
- **LibSQL Database:** The existing `LibSqlBackend` implementation from the `ironclaw::db::libsql` module will be used directly. It provides an embedded SQLite-compatible backend, perfect for mobile (iOS/Android) and desktop storage.

## 3. The Bridge Layer (ironclaw_flutter)

The bridge crate will be responsible for:

### 1. Handle Management
Wrapping the `Agent` and `AppComponents` in a thread-safe handle (e.g., `Arc<Mutex<AgentHandle>>`) to persist state across the bridge.

### 2. Initialization API
```rust
pub async fn init_agent(config_data: ConfigData, app_dir: String) -> Result<AgentHandle> {
    // 1. Setup paths (DB, logs, tools) using app_dir from Flutter
    let db_path = Path::new(&app_dir).join("ironclaw.db");

    // 2. Initialize the EXISTING LibSqlBackend from ironclaw core
    let backend = LibSqlBackend::new_local(&db_path).await?;
    let db = Arc::new(backend);

    // 3. Build AppComponents via AppBuilder, injecting the pre-init DB
    let mut builder = AppBuilder::new(config_data, ...);
    builder.with_database(db);
    let components = builder.build_all().await?;

    // 4. Initialize Agent and return handle
}
```

### 3. Streaming Events
Using FRB v2's `StreamSink` to push real-time updates to Flutter:
- `MessageChunk`: For streaming LLM responses.
- `ToolCall`: To show which tool is currently running.
- `StatusUpdate`: For system-level logs and heartbeat status.

### 3. The Flutter Channel (Bridge Side)
To bridge the core `Agent` to the Flutter UI without modifying the `ironclaw` project, we implement the `ironclaw::channels::Channel` trait on a local `FlutterChannel` struct within the bridge crate.

- **Orphan Rule Compliance:** By defining a local struct (`FlutterChannel`) and implementing the foreign trait (`Channel`), we avoid sync issues with the upstream core.
- **Event Routing:** The `FlutterChannel` holds a `StreamSink<ChatEvent>`, allowing it to catch `StatusUpdate` and `OutgoingResponse` calls from the core and pipe them directly into the Flutter UI's asynchronous stream.

## 4. Platform-Specific Considerations

### Database (LibSQL)
- **Reuse:** We use the native `LibSqlBackend` from the core project without modification to ensure schema and migration parity.
- **Pathing:** On mobile, the database file must reside in the application's documents directory. Flutter's `path_provider` will retrieve this location and pass it to the bridge during `init_agent`.
- **Injection:** By using `AppBuilder::with_database(db)`, we skip the core's default database initialization (which usually relies on environment variables or config files) and provide our platform-specific handle directly.

## 5. Integration Plan

### Phase 1: Bridge Prototyping
1. Create `ironclaw_flutter` crate (the bridge).
2. Define a minimal `init` and `chat` API.
3. Verify `libsql` works on a target platform (e.g., macOS/Simulator).

### Phase 2: Bridge Adapter (FlutterChannel)
1. Implement the `FlutterChannel` struct in the bridge crate.
2. Implement the `ironclaw::channels::Channel` trait for `FlutterChannel`.
3. Map IronClaw's `OutgoingResponse` and `StatusUpdate` to FRB-compatible `ChatEvent` structs within the bridge.
4. Ensure zero modifications are required in the `ironclaw` core.

### Phase 3: Flutter UI Development
1. Build a responsive Chat UI.
2. Implement a "Provider" or "Bloc" that manages the Rust handle.
3. Add a "Developer Console" to view the agent's internal reasoning and logs (using `LogBroadcaster`).

## 6. Structure Recommendations

- **Crate Split:** Keep the bridge in a separate crate to avoid bloating the core `ironclaw` crate with FRB dependencies.
- **Feature Flags:** Use feature flags to selectively disable heavy components (like Docker/Sandbox) on mobile platforms where they are unavailable.
- **Async Everywhere:** Leverage IronClaw's existing `tokio` integration, as FRB v2 handles async Rust seamlessly.
