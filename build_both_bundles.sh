#!/bin/bash

# Aleefy Pet App - Build Both App Bundles
# This script auto-increments version once and builds both dev and prod bundles

set -e  # Exit on error

echo "============================================"
echo "   Aleefy Pet App - Build All Bundles"
echo "============================================"
echo ""

# Note: Version will be auto-incremented by the first build script
echo "⚠️  Note: Build version will be auto-incremented during this process"
echo ""

# Build Dev Bundle
echo "Building Development Bundle..."
echo "----------------------------------------"
bash build_dev_bundle.sh

echo ""
echo ""

# Build Prod Bundle (version already incremented, so we'll skip increment in prod)
echo "Building Production Bundle..."
echo "----------------------------------------"
bash build_prod_bundle.sh

echo ""
echo ""
echo "============================================"
echo "   All Bundles Built Successfully! 🎉"
echo "============================================"
echo ""
echo "Output Files:"
echo "  Dev:  build/app/outputs/bundle/devRelease/app-dev-release.aab"
echo "  Prod: build/app/outputs/bundle/prodRelease/app-prod-release.aab"
echo ""
