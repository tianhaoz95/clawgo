#!/bin/bash
set -e
TEMP_DIR="/Users/tianhaozhou/github/clawgo/clawgo/cyberclaw/ios/Pods/build_tool_repro"
mkdir -p "$TEMP_DIR"
echo "Using temp dir: $TEMP_DIR"
cd "$TEMP_DIR"
BUILD_TOOL_PKG_DIR="/Users/tianhaozhou/github/clawgo/clawgo/cyberclaw/rust_builder/cargokit/build_tool"
DART="/Users/tianhaozhou/Tools/flutter/bin/cache/dart-sdk/bin/dart"

cat << EOF > "pubspec.yaml"
name: build_tool_runner
version: 1.0.0
publish_to: none
resolution: workspace

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  build_tool:
    path: "$BUILD_TOOL_PKG_DIR"
EOF

"$DART" pub get --no-precompile
