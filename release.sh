#!/bin/bash
set -e

echo "🔧 Running release with standard-version..."
npx standard-version

echo "📤 Pushing tags and changelog..."
git push origin main --follow-tags

echo "✅ Release done!"