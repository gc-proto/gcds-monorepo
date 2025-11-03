#!/bin/bash

# Setup script for GC Proto Monorepo - Fork Repository Cloning
# This script automates the cloning of the three fork repositories required for development

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the correct directory
if [[ ! -f "package.json" ]] || [[ ! -f "pnpm-workspace.yaml" ]]; then
    print_error "This script must be run from the monorepo root directory"
    print_error "Please run: cd gcds-monorepo && ./scripts/setup-forks.sh"
    exit 1
fi

# Check if git is available
if ! command -v git &> /dev/null; then
    print_error "Git is not installed or not in PATH"
    exit 1
fi

# Check if pnpm is available
if ! command -v pnpm &> /dev/null; then
    print_error "pnpm is not installed or not in PATH"
    print_error "Please install pnpm: npm install -g pnpm"
    exit 1
fi

print_status "Starting GC Proto Monorepo setup..."

# Create packages directory if it doesn't exist
mkdir -p packages
cd packages

# Fork repositories configuration
declare -A FORK_REPOS=(
    ["gcds-examples"]="https://github.com/gc-proto/gcds-examples.git"
    ["gcds-components"]="https://github.com/gc-proto/gcds-components.git"
    ["gcds-shortcuts"]="https://github.com/gc-proto/gcds-css-shortcuts.git"
)

# Clone or update each fork repository
for repo_name in "${!FORK_REPOS[@]}"; do
    repo_url="${FORK_REPOS[$repo_name]}"
    
    if [[ -d "$repo_name" ]]; then
        print_warning "Directory $repo_name already exists"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo    # Move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Updating $repo_name..."
            cd "$repo_name"
            git fetch origin
            git reset --hard origin/main
            cd ..
            print_success "Updated $repo_name"
        else
            print_status "Skipping $repo_name"
        fi
    else
        print_status "Cloning $repo_name from $repo_url..."
        if git clone "$repo_url" "$repo_name"; then
            print_success "Successfully cloned $repo_name"
        else
            print_error "Failed to clone $repo_name"
            exit 1
        fi
    fi
done

# Return to monorepo root
cd ..

# Install dependencies and link workspaces
print_status "Installing dependencies and linking workspaces..."
if pnpm install; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Verify setup
print_status "Verifying setup..."

# Check if all expected directories exist
expected_dirs=("packages/gcds-examples" "packages/gcds-components" "packages/gcds-shortcuts")
missing_dirs=()

for dir in "${expected_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
        missing_dirs+=("$dir")
    fi
done

if [[ ${#missing_dirs[@]} -gt 0 ]]; then
    print_error "Setup verification failed. Missing directories:"
    for dir in "${missing_dirs[@]}"; do
        print_error "  - $dir"
    done
    exit 1
fi

# Test build process
print_status "Testing build process..."
if pnpm build; then
    print_success "Build test completed successfully"
else
    print_warning "Build test failed, but setup is complete. Check your configuration."
fi

print_success "Setup completed successfully!"
print_status "Next steps:"
echo "  1. Run 'pnpm dev' to start the development server"
echo "  2. Check the generated files in packages/gcds-examples/templates/"
echo "  3. Begin development following the workflow in SETUP.md"
