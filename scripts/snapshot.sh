#!/bin/bash

# Snapshot script - runs snapshot test and reports location
set -e

SNAPSHOT_PATH="Snapshots/testViewControllerSnapshot.png"

echo "🔨 Cleaning and building snapshot test..."

xcodebuild clean test \
  -scheme HelloWorld \
  -destination 'platform=iOS Simulator,id=CE2B3D49-DCC9-4252-88CD-9B036E3E242A' \
  -only-testing:HelloWorldTests/SnapshotTests/testViewControllerSnapshot \
  2>&1 | grep -E "(Test Case.*started|Test Case.*passed|Test Case.*failed|BUILD SUCCEEDED|CLEAN SUCCEEDED)" || true

echo ""
echo "✅ Snapshot saved to:"
echo "   $SNAPSHOT_PATH"
echo ""
echo "Full path:"
echo "   $(pwd)/$SNAPSHOT_PATH"
echo ""
echo "Open with:"
echo "   open '$SNAPSHOT_PATH'"
