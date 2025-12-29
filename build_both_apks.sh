#!/bin/bash

# Aleefy Pet App - Multi-Environment APK Builder
# This script builds separate APKs for Development and Production environments

echo "============================================"
echo "   Aleefy Pet App - Multi-Build Script"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
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

# Step 3: Build Development APK
echo "============================================"
echo -e "${CYAN}Building DEVELOPMENT APK${NC}"
echo "============================================"
echo -e "${BLUE}Step 3a: Building Dev APK (this may take a few minutes)...${NC}"
flutter build apk --release --flavor dev --dart-define=ENVIRONMENT=dev
echo -e "${GREEN}✓ Dev APK build completed${NC}"
echo ""

# Copy Dev APK to output directory
DEV_APK_SOURCE="build/app/outputs/flutter-apk/app-dev-release.apk"
DEV_APK_DEST="$OUTPUT_DIR/aleefy-dev.apk"
if [ -f "$DEV_APK_SOURCE" ]; then
    cp "$DEV_APK_SOURCE" "$DEV_APK_DEST"
    echo -e "${GREEN}✓ Dev APK copied to: $DEV_APK_DEST${NC}"
else
    echo -e "${RED}✗ Dev APK not found at expected location${NC}"
fi
echo ""

# Step 4: Build Production APK
echo "============================================"
echo -e "${CYAN}Building PRODUCTION APK${NC}"
echo "============================================"
echo -e "${BLUE}Step 3b: Building Prod APK (this may take a few minutes)...${NC}"
flutter build apk --release --flavor prod --dart-define=ENVIRONMENT=prod
echo -e "${GREEN}✓ Prod APK build completed${NC}"
echo ""

# Copy Prod APK to output directory
PROD_APK_SOURCE="build/app/outputs/flutter-apk/app-prod-release.apk"
PROD_APK_DEST="$OUTPUT_DIR/aleefy-prod.apk"
if [ -f "$PROD_APK_SOURCE" ]; then
    cp "$PROD_APK_SOURCE" "$PROD_APK_DEST"
    echo -e "${GREEN}✓ Prod APK copied to: $PROD_APK_DEST${NC}"
else
    echo -e "${RED}✗ Prod APK not found at expected location${NC}"
fi
echo ""

# Step 5: Show summary
echo "============================================"
echo -e "${GREEN}SUCCESS! Both APKs built successfully!${NC}"
echo "============================================"
echo ""
echo -e "${YELLOW}📦 DEVELOPMENT APK${NC}"
echo "────────────────────────────────────────────"
echo "Location: $DEV_APK_DEST"
if [ -f "$DEV_APK_DEST" ]; then
    echo "Size:     $(ls -lh "$DEV_APK_DEST" | awk '{print $5}')"
    echo "API URL:  https://api-dev.aleefy-app.com/api/v1"
    echo "App ID:   com.example.petapp.dev"
    echo "App Name: Aleefy Dev"
fi
echo ""

echo -e "${YELLOW}📦 PRODUCTION APK${NC}"
echo "────────────────────────────────────────────"
echo "Location: $PROD_APK_DEST"
if [ -f "$PROD_APK_DEST" ]; then
    echo "Size:     $(ls -lh "$PROD_APK_DEST" | awk '{print $5}')"
    echo "API URL:  https://api.aleefy-app.com/api/v1"
    echo "App ID:   com.example.petapp"
    echo "App Name: Aleefy"
fi
echo ""

echo -e "${CYAN}📁 All APKs Location:${NC}"
echo "   $OUTPUT_DIR/"
echo ""

echo -e "${YELLOW}ℹ️  Key Differences:${NC}"
echo "────────────────────────────────────────────"
echo "• Dev APK uses development API server"
echo "• Prod APK uses production API server"
echo "• Both can be installed side-by-side"
echo "• Different package IDs prevent conflicts"
echo ""

echo -e "${CYAN}Next Steps:${NC}"
echo "────────────────────────────────────────────"
echo "1. Test Dev APK with development backend"
echo "2. Test Prod APK with production backend"
echo "3. Verify API endpoints are correct"
echo "4. Transfer APKs to Android devices"
echo "5. Enable 'Install from Unknown Sources'"
echo "6. Install and test both versions"
echo ""
echo "============================================"

