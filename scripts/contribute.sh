#!/bin/bash

# Script to copy .html files from gcds.test.canada.ca build to appropriate packages
# and prepare them for contribution via PR
# - en/templates/ and fr/templates/ -> gcds-examples/templates/english|french
# - en/components/ and fr/components/ -> gcds-components (TBD structure)

set -e  # Exit on error

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the monorepo root (parent of scripts/)
MONOREPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Set paths relative to monorepo root
SOURCE_DIR="${MONOREPO_ROOT}/apps/gcds.test.canada.ca/src"
BUILD_DIR="${MONOREPO_ROOT}/apps/gcds.test.canada.ca/_site"
EXAMPLES_DEST="${MONOREPO_ROOT}/packages/gcds-examples"
COMPONENTS_DEST="${MONOREPO_ROOT}/packages/gcds-components"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== GC Design System Contribution Helper ===${NC}"
echo ""

# Track copied files by package
declare -a examples_files=()
declare -a components_files=()

echo "Copying .html files to appropriate packages..."

# Create destination directories
mkdir -p "${EXAMPLES_DEST}/templates/english"
mkdir -p "${EXAMPLES_DEST}/templates/french"

# Copy template HTML files from build output: en/ -> gcds-examples/templates/english
# These are the built template files at the top level (institutional-landing-page.html, topic-page.html)
if [ -d "${BUILD_DIR}/en" ]; then
  for template_file in "${BUILD_DIR}/en"/*.html; do
    if [ -f "${template_file}" ]; then
      filename=$(basename "${template_file}")
      # Skip index and component files - only copy actual templates
      if [[ "$filename" != "index.html" && "$filename" != "sample-component.html" ]]; then
        cp "${template_file}" "${EXAMPLES_DEST}/templates/english/${filename}"
        examples_files+=("templates/english/${filename}")
        echo -e "  ${GREEN}✓${NC} Copied: templates/english/${filename}"
      fi
    fi
  done
fi

# Copy template HTML files from build output: fr/ -> gcds-examples/templates/french
# These are the built template files at the top level (page-accueil-institutionnelle.html, page-sujets.html)
if [ -d "${BUILD_DIR}/fr" ]; then
  for template_file in "${BUILD_DIR}/fr"/*.html; do
    if [ -f "${template_file}" ]; then
      filename=$(basename "${template_file}")
      # Skip index and component files - only copy actual templates
      if [[ "$filename" != "index.html" && "$filename" != "exemple-composant.html" ]]; then
        cp "${template_file}" "${EXAMPLES_DEST}/templates/french/${filename}"
        examples_files+=("templates/french/${filename}")
        echo -e "  ${GREEN}✓${NC} Copied: templates/french/${filename}"
      fi
    fi
  done
fi

# Copy components: en/components -> gcds-components (structure TBD)
if [ -d "${SOURCE_DIR}/en/components" ]; then
  while IFS= read -r source_file; do
    rel_path="${source_file#${SOURCE_DIR}/en/components/}"
    built_file="${BUILD_DIR}/en/components/${rel_path}"
    # TODO: Define destination structure in gcds-components
    components_files+=("en/${rel_path}")
    echo -e "  ${YELLOW}ℹ${NC} Found component (en): ${rel_path} (destination structure TBD)"
  done < <(find "${SOURCE_DIR}/en/components" -name "*.html" -type f)
fi

# Copy components: fr/components -> gcds-components (structure TBD)
if [ -d "${SOURCE_DIR}/fr/components" ]; then
  while IFS= read -r source_file; do
    rel_path="${source_file#${SOURCE_DIR}/fr/components/}"
    built_file="${BUILD_DIR}/fr/components/${rel_path}"
    # TODO: Define destination structure in gcds-components
    components_files+=("fr/${rel_path}")
    echo -e "  ${YELLOW}ℹ${NC} Found component (fr): ${rel_path} (destination structure TBD)"
  done < <(find "${SOURCE_DIR}/fr/components" -name "*.html" -type f)
fi

# Copy assets if they exist
if [ -d "${BUILD_DIR}/assets" ]; then
  cp -r "${BUILD_DIR}/assets" "${EXAMPLES_DEST}/templates/"
  echo -e "  ${GREEN}✓${NC} Copied: assets/"
fi

# Copy root HTML files if they exist
if [ -f "${SOURCE_DIR}/index.html" ] && [ -f "${BUILD_DIR}/index.html" ]; then
  cp "${BUILD_DIR}/index.html" "${EXAMPLES_DEST}/templates/"
  echo -e "  ${GREEN}✓${NC} Copied: index.html"
fi

if [ -f "${SOURCE_DIR}/not-index.html" ] && [ -f "${BUILD_DIR}/not-index.html" ]; then
  cp "${BUILD_DIR}/not-index.html" "${EXAMPLES_DEST}/templates/"
  echo -e "  ${GREEN}✓${NC} Copied: not-index.html"
fi

echo ""
echo -e "${GREEN}✓ Files copied successfully!${NC}"
echo ""

# Show summary of copied files
if [ ${#examples_files[@]} -gt 0 ]; then
  echo -e "${BLUE}Summary - Files copied to gcds-examples:${NC}"
  for file in "${examples_files[@]}"; do
    echo -e "  • ${file}"
  done
  echo ""
fi

if [ ${#components_files[@]} -gt 0 ]; then
  echo -e "${BLUE}Summary - Component files found:${NC}"
  for file in "${components_files[@]}"; do
    echo -e "  • ${file}"
  done
  echo ""
fi

# Function to prepare PR for a package
prepare_pr() {
  local package_dir=$1
  local package_name=$2
  shift 2
  local files=("$@")
  
  if [ ${#files[@]} -eq 0 ]; then
    return
  fi
  
  echo -e "${BLUE}=== Preparing PR for ${package_name} ===${NC}"
  
  cd "${package_dir}"
  
  # Check if we're in a git repository
  if [ ! -d .git ]; then
    echo -e "${RED}✗ Error: ${package_dir} is not a git repository${NC}"
    echo "  Please run setup-forks.sh first"
    cd - > /dev/null
    return 1
  fi
  
  # Get current branch
  current_branch=$(git branch --show-current)
  
  # Check for uncommitted changes
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${YELLOW}⚠ Warning: You have uncommitted changes in ${package_name}${NC}"
    echo ""
  fi
  
  # Show files to be contributed
  echo "Files to be contributed:"
  for file in "${files[@]}"; do
    if [ -f "$file" ]; then
      status=$(git status --porcelain "$file" | cut -c1-2)
      if [ -z "$status" ]; then
        echo -e "  ${BLUE}·${NC} ${file} (unchanged)"
      elif [ "$status" = "??" ]; then
        echo -e "  ${GREEN}+${NC} ${file} (new)"
      else
        echo -e "  ${YELLOW}M${NC} ${file} (modified)"
      fi
    fi
  done
  echo ""
  
  # Suggest branch name based on first new file
  suggested_branch=""
  for file in "${files[@]}"; do
    status=$(git status --porcelain "$file" 2>/dev/null | cut -c1-2)
    if [ "$status" = "??" ] || [ "$status" = " M" ] || [ "$status" = "M " ]; then
      # Extract a meaningful name from the file path
      filename=$(basename "$file" .html)
      suggested_branch="feature/${filename}"
      break
    fi
  done
  
  if [ -z "$suggested_branch" ]; then
    suggested_branch="feature/update-templates"
  fi
  
  # Check if we're on main branch
  if [ "$current_branch" = "main" ]; then
    echo -e "${YELLOW}You are currently on the 'main' branch.${NC}"
    echo "Suggested branch name: ${suggested_branch}"
    echo ""
    read -p "Enter branch name (press Enter to use suggestion, or type your own): " user_branch
    
    if [ -z "$user_branch" ]; then
      branch_name="$suggested_branch"
    else
      branch_name="$user_branch"
    fi
    
    # Check if branch already exists
    if git show-ref --verify --quiet "refs/heads/${branch_name}"; then
      echo -e "${YELLOW}Branch '${branch_name}' already exists.${NC}"
      read -p "Switch to it? (y/n): " switch_branch
      if [ "$switch_branch" = "y" ]; then
        git checkout "${branch_name}"
      else
        echo "Staying on current branch. Please resolve manually."
        cd - > /dev/null
        return 1
      fi
    else
      echo -e "${GREEN}Creating new branch: ${branch_name}${NC}"
      git checkout -b "${branch_name}"
    fi
  else
    branch_name="$current_branch"
    echo -e "Current branch: ${GREEN}${branch_name}${NC}"
  fi
  
  echo ""
  read -p "Stage and commit these files? (y/n): " do_commit
  
  if [ "$do_commit" = "y" ]; then
    # Stage files
    for file in "${files[@]}"; do
      if [ -f "$file" ]; then
        git add "$file"
        echo -e "  ${GREEN}✓${NC} Staged: ${file}"
      fi
    done
    
    echo ""
    echo "Enter commit message (or press Enter for default):"
    default_msg="feat(examples): add new templates"
    read -p "> " commit_msg
    
    if [ -z "$commit_msg" ]; then
      commit_msg="$default_msg"
    fi
    
    git commit -m "$commit_msg"
    echo -e "${GREEN}✓ Changes committed${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Push to your fork: ${YELLOW}git push origin ${branch_name}${NC}"
    echo "2. Open a PR on GitHub from:"
    echo "   ${GREEN}gc-proto/${package_name}:${branch_name}${NC}"
    echo "   to: ${BLUE}cds-snc/${package_name}:main${NC}"
  else
    echo "Skipping commit. Files are copied but not committed."
  fi
  
  cd - > /dev/null
  echo ""
}

# Prepare PR for gcds-examples if there are files
if [ ${#examples_files[@]} -gt 0 ]; then
  prepare_pr "${EXAMPLES_DEST}" "gcds-examples" "${examples_files[@]}"
fi

# Prepare PR for gcds-components if there are files (when structure is defined)
if [ ${#components_files[@]} -gt 0 ]; then
  echo -e "${YELLOW}ℹ Component files found but contribution process not yet implemented${NC}"
  echo "  Files: ${components_files[*]}"
fi

echo -e "${GREEN}=== Done! ===${NC}"
