#!/usr/bin/bash
# Take the output tag as a parameter and upload all files from dist/ via gh release upload
for file in dist/*; do
  gh release upload $1 "$file"
done