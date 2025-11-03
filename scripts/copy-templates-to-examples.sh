#!/bin/bash

# Script to copy only .html files (that were originally .html in source) from gcds.test.canada.ca build to gcds-examples package
# This excludes HTML files generated from .njk or .md files
# This should be run as part of the PR workflow, not during regular builds

SOURCE_DIR="apps/gcds.test.canada.ca/src/templates"
BUILD_DIR="apps/gcds.test.canada.ca/_site/templates"
DEST_DIR="packages/gcds-examples/templates"

echo "Copying .html files (from .html sources only) to ${DEST_DIR}..."

# Create destination directories if they don't exist
mkdir -p "${DEST_DIR}/english"
mkdir -p "${DEST_DIR}/french"

# Find all .html files in the source directory and copy their built versions
if [ -d "${SOURCE_DIR}/english" ]; then
  find "${SOURCE_DIR}/english" -name "*.html" -type f | while read source_file; do
    # Get the relative path from SOURCE_DIR/english
    rel_path="${source_file#${SOURCE_DIR}/english/}"
    # Corresponding built file
    built_file="${BUILD_DIR}/english/${rel_path}"
    dest_file="${DEST_DIR}/english/${rel_path}"
    
    if [ -f "${built_file}" ]; then
      dest_dir=$(dirname "${dest_file}")
      mkdir -p "${dest_dir}"
      cp "${built_file}" "${dest_file}"
      echo "  Copied: english/${rel_path}"
    fi
  done
fi

if [ -d "${SOURCE_DIR}/french" ]; then
  find "${SOURCE_DIR}/french" -name "*.html" -type f | while read source_file; do
    # Get the relative path from SOURCE_DIR/french
    rel_path="${source_file#${SOURCE_DIR}/french/}"
    # Corresponding built file
    built_file="${BUILD_DIR}/french/${rel_path}"
    dest_file="${DEST_DIR}/french/${rel_path}"
    
    if [ -f "${built_file}" ]; then
      dest_dir=$(dirname "${dest_file}")
      mkdir -p "${dest_dir}"
      cp "${built_file}" "${dest_file}"
      echo "  Copied: french/${rel_path}"
    fi
  done
fi

# Copy assets and other root files if they exist
if [ -d "${BUILD_DIR}/assets" ]; then
  cp -r "${BUILD_DIR}/assets" "${DEST_DIR}/"
  echo "  Copied: assets/"
fi

if [ -f "${SOURCE_DIR}/../index.html" ] && [ -f "${BUILD_DIR}/../index.html" ]; then
  cp "${BUILD_DIR}/../index.html" "${DEST_DIR}/"
  echo "  Copied: index.html"
fi

if [ -f "${SOURCE_DIR}/../not-index.html" ] && [ -f "${BUILD_DIR}/../not-index.html" ]; then
  cp "${BUILD_DIR}/../not-index.html" "${DEST_DIR}/"
  echo "  Copied: not-index.html"
fi

echo "Done! HTML files (from .html sources only) copied to gcds-examples package."
