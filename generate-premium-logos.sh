#!/bin/bash

# Premium Logo Generation Script for Subcriot Tracker
# Creates App Store quality logos in all required formats

echo "🎨 Generating Premium Logos for Subcriot Tracker..."

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not found. Installing..."
    if command -v brew &> /dev/null; then
        brew install imagemagick
    else
        echo "Please install ImageMagick manually: https://imagemagick.org/script/download.php"
        exit 1
    fi
fi

# Create output directories
mkdir -p assets/logo/png
mkdir -p assets/logo/app-icons

echo "📱 Generating App Store Icons..."

# App Store Icon (1024x1024)
convert assets/logo/subcriot-tracker-app-icon.svg -resize 1024x1024 assets/logo/app-icons/app-icon-1024.png

# iOS App Icons
convert assets/logo/subcriot-tracker-app-icon.svg -resize 180x180 assets/logo/app-icons/app-icon-180.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 167x167 assets/logo/app-icons/app-icon-167.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 152x152 assets/logo/app-icons/app-icon-152.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 120x120 assets/logo/app-icons/app-icon-120.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 87x87 assets/logo/app-icons/app-icon-87.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 80x80 assets/logo/app-icons/app-icon-80.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 76x76 assets/logo/app-icons/app-icon-76.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 60x60 assets/logo/app-icons/app-icon-60.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 58x58 assets/logo/app-icons/app-icon-58.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 40x40 assets/logo/app-icons/app-icon-40.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 29x29 assets/logo/app-icons/app-icon-29.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 20x20 assets/logo/app-icons/app-icon-20.png

echo "🎯 Generating Logo Variations..."

# Premium Logo Variations
convert assets/logo/subcriot-tracker-premium-logo.svg -resize 400x400 assets/logo/png/premium-logo-400.png
convert assets/logo/subcriot-tracker-premium-logo.svg -resize 800x800 assets/logo/png/premium-logo-800.png
convert assets/logo/subcriot-tracker-premium-logo.svg -resize 1200x1200 assets/logo/png/premium-logo-1200.png

# Ultra Premium Logo
convert assets/logo/subcriot-tracker-ultra-premium-logo.svg -resize 400x400 assets/logo/png/ultra-premium-logo-400.png
convert assets/logo/subcriot-tracker-ultra-premium-logo.svg -resize 800x800 assets/logo/png/ultra-premium-logo-800.png

# Professional Logo
convert assets/logo/subcriot-tracker-professional-logo.svg -resize 400x400 assets/logo/png/professional-logo-400.png
convert assets/logo/subcriot-tracker-professional-logo.svg -resize 800x800 assets/logo/png/professional-logo-800.png

# Horizontal Logo
convert assets/logo/subcriot-tracker-horizontal-logo.svg -resize 800x200 assets/logo/png/horizontal-logo-800.png
convert assets/logo/subcriot-tracker-horizontal-logo.svg -resize 1200x300 assets/logo/png/horizontal-logo-1200.png
convert assets/logo/subcriot-tracker-horizontal-logo.svg -resize 1600x400 assets/logo/png/horizontal-logo-1600.png

echo "📄 Generating Favicon..."
# Favicon (32x32)
convert assets/logo/subcriot-tracker-app-icon.svg -resize 32x32 assets/logo/png/favicon-32.png
convert assets/logo/subcriot-tracker-app-icon.svg -resize 16x16 assets/logo/png/favicon-16.png

echo "✅ Logo generation complete!"
echo ""
echo "📁 Generated files:"
echo "   App Icons: assets/logo/app-icons/"
echo "   Logo PNGs: assets/logo/png/"
echo "   SVG Sources: assets/logo/*.svg"
echo ""
echo "🎨 Logo Variations:"
echo "   • Premium Logo - Modern gradient with card stack"
echo "   • Ultra Premium - Multi-color gradient with sparkles"
echo "   • Professional - Fintech-inspired blue gradient"
echo "   • App Icon - App Store optimized 1024x1024"
echo "   • Horizontal - For headers and documentation"
echo ""
echo "🚀 Ready for App Store submission!"
