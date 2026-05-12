#!/bin/bash

# Aleefy Pet App - Development App Bundle Builder
# This script builds a development App Bundle (.aab) for testing

set -e  # Exit on error

echo "============================================"
echo "   Aleefy Pet App - Dev Bundle"
echo "============================================"
echo ""

# Step 1: Clean previous builds
echo "Step 1: Cleaning previous builds..."
flutter clean
echo "✓ Clean completed"
echo ""

# Step 2: Get dependencies
echo "Step 2: Getting dependencies..."
flutter pub get
echo "✓ Dependencies installed"
echo ""

# Step 3: Build development app bundle
echo "Step 3: Building Development App Bundle..."
echo "Using Development API: https://api-dev.aleefy-app.com/api/v1"
echo ""

flutter build appbundle --release --flavor dev -t lib/main.dart

echo "✓ App Bundle build completed"
echo ""

# Step 4: Verify and show output location
BUNDLE_PATH="build/app/outputs/bundle/devRelease/app-dev-release.aab"

if [ -f "$BUNDLE_PATH" ]; then
    echo "✓ Development App Bundle found at:"
    echo "  $BUNDLE_PATH"
    echo ""

    # Get file size
    SIZE=$(du -h "$BUNDLE_PATH" | cut -f1)
    echo "  Bundle Size: $SIZE"
    echo ""

    echo "============================================"
    echo "   Build Successful! 🎉"
    echo "============================================"
    echo ""
    echo "Next Steps:"
    echo "1. Test the bundle on a device:"
    echo "   bundletool build-apks --bundle=$BUNDLE_PATH --output=app-dev.apks"
    echo "   bundletool install-apks --apks=app-dev.apks"
    echo ""
    echo "2. Upload to Google Play Console (Internal Testing):"
    echo "   - Go to https://play.google.com/console"
    echo "   - Navigate to your app"
    echo "   - Go to Release > Testing > Internal testing"
    echo "   - Create new release and upload the .aab file"
    echo ""
else
    echo "✗ Development App Bundle not found at expected location"
    echo "  Expected: $BUNDLE_PATH"
    echo ""
    echo "Checking for any .aab files..."
    find build -name "*.aab" 2>/dev/null || echo "  No .aab files found"
    exit 1
fi

