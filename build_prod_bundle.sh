#!/bin/bash

# Aleefy Pet App - Production App Bundle Builder
# This script builds a production-ready App Bundle (.aab) for Google Play Store

set -e  # Exit on error

echo "============================================"
echo "   Aleefy Pet App - Production Bundle"
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

# Step 3: Build production app bundle
echo "Step 3: Building Production App Bundle..."
echo "Using Production API: https://api.aleefy-app.com/api/v1"
echo ""

flutter build appbundle --release --flavor prod -t lib/main.dart

echo "✓ App Bundle build completed"
echo ""

# Step 4: Verify and show output location
BUNDLE_PATH="build/app/outputs/bundle/prodRelease/app-prod-release.aab"

if [ -f "$BUNDLE_PATH" ]; then
    echo "✓ Production App Bundle found at:"
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
    echo "   bundletool build-apks --bundle=$BUNDLE_PATH --output=app.apks"
    echo "   bundletool install-apks --apks=app.apks"
    echo ""
    echo "2. Upload to Google Play Console:"
    echo "   - Go to https://play.google.com/console"
    echo "   - Navigate to your app"
    echo "   - Go to Release > Production"
    echo "   - Create new release and upload the .aab file"
    echo ""
else
    echo "✗ Production App Bundle not found at expected location"
    echo "  Expected: $BUNDLE_PATH"
    echo ""
    echo "Checking for any .aab files..."
    find build -name "*.aab" 2>/dev/null || echo "  No .aab files found"
    exit 1
fi

