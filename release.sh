#!/bin/bash
set -e

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

echo "🔧 Running release with standard-version..."
npx standard-version

echo "📤 Pushing tags and changelog..."
git push origin main --follow-tags

echo "✅ Release done!"