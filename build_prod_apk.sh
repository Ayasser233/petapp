#!/bin/bash

# Aleefy Pet App - Production APK Builder
# This script builds a production APK that uses prod API

echo "============================================"
echo "   Aleefy Pet App - Prod APK Builder"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create output directory
OUTPUT_DIR="build/apks"
mkdir -p "$OUTPUT_DIR"

# Step 1: Clean previous builds
echo -e "${BLUE}Step 1: Cleaning previous builds...${NC}"
flutter clean
echo -e "${GREEN}✓ Clean completed${NC}"
echo ""

# Step 2: Get dependencies
echo -e "${BLUE}Step 2: Getting dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Step 3: Build Production APK
echo -e "${BLUE}Step 3: Building Production APK...${NC}"
echo -e "${YELLOW}Using Production API: https://api.aleefy-app.com/api/v1${NC}"
echo ""
flutter build apk --release --flavor prod --dart-define=ENVIRONMENT=prod
echo -e "${GREEN}✓ APK build completed${NC}"
echo ""

# Copy APK to output directory
APK_SOURCE="build/app/outputs/flutter-apk/app-prod-release.apk"
APK_DEST="$OUTPUT_DIR/aleefy-prod.apk"
if [ -f "$APK_SOURCE" ]; then
    cp "$APK_SOURCE" "$APK_DEST"
    echo -e "${GREEN}✓ APK copied to: $APK_DEST${NC}"
else
    echo -e "${RED}✗ APK not found at expected location${NC}"
    exit 1
fi
echo ""

# Step 4: Show APK details
echo "============================================"
echo -e "${GREEN}SUCCESS! Prod APK built successfully!${NC}"
echo "============================================"
echo ""
echo "📦 APK Details:"
echo "────────────────────────────────────────────"
echo "Location:   $APK_DEST"
echo "Size:       $(ls -lh "$APK_DEST" | awk '{print $5}')"
echo "API URL:    https://api.aleefy-app.com/api/v1"
echo "App ID:     com.example.petapp"
echo "App Name:   Aleefy"
echo "Environment: PRODUCTION"
echo ""
echo "⚠️  Important:"
echo "This is a PRODUCTION build using live API!"
echo ""
echo "Next Steps:"
echo "1. Transfer APK to your Android device"
echo "2. Enable 'Install from Unknown Sources' in device settings"
echo "3. Install and test with production backend"
echo "4. Verify API connections to production server"
echo ""
echo "============================================"

