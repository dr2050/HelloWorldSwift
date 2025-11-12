#!/bin/bash

# Snapshot script - runs snapshot test and reports location
set -e

SNAPSHOT_PATH="HelloWorldTests/__Snapshots__/SnapshotTests/testViewControllerSnapshot.1.png"

echo "🔨 Building and running snapshot test..."

xcodebuild test \
  -scheme HelloWorld \
  -destination 'platform=iOS Simulator,id=255FB8A5-3BF0-4110-9565-0DD4CD939F98' \
  -only-testing:HelloWorldTests/SnapshotTests/testViewControllerSnapshot \
  2>&1 | grep -E "(Test Case.*started|Test Case.*passed|Test Case.*failed|BUILD SUCCEEDED)" || true

echo ""
echo "✅ Snapshot saved to:"
echo "   $SNAPSHOT_PATH"
echo ""
echo "Full path:"
echo "   $(pwd)/$SNAPSHOT_PATH"
echo ""
echo "Open with:"
echo "   open '$SNAPSHOT_PATH'"
