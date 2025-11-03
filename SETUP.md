# Setup Instructions - GC Proto Monorepo

## Prerequisites
- Node.js 18+ and pnpm 8+ installed
- Git configured with GitHub access

## Initial Setup

### 1. Clone and Install
```bash
git clone https://github.com/gc-proto/gcds-monorepo.git
cd gcds-monorepo
pnpm install
```

### 2. Automated Fork Repository Setup
The fork repositories are gitignored and must be cloned locally. This keeps the main repository clean while enabling full development capabilities.

**Option A: Automated Setup (Recommended)**
```bash
# Run the automated setup script
pnpm setup

# Or alternatively:
pnpm setup:forks
```

**Option B: Manual Setup**
```bash
# Navigate to packages directory
cd packages

# Clone the three fork repositories (these are gitignored)
git clone https://github.com/gc-proto/gcds-examples.git gcds-examples
git clone https://github.com/gc-proto/gcds-components.git gcds-components  
git clone https://github.com/gc-proto/gcds-css-shortcuts.git gcds-shortcuts

# Return to monorepo root
cd ..

# Install all dependencies and link workspaces
pnpm install
```

The automated setup script will:
- Clone all three fork repositories
- Handle existing directories (with confirmation)
- Install and link all workspace dependencies
- Verify the setup with a test build
- Provide clear status messages throughout the process

### 3. Verify Setup
```bash
# Verify all packages are present
ls packages/
# Should show: gcds-components/ gcds-examples/ gcds-shortcuts/

# Test the build process
pnpm build
# Should generate 3 HTML files in packages/gcds-examples/templates/

# Start development server  
pnpm dev
# Should start Eleventy with live reload at http://localhost:8080
```

## Development Workflow

### Repository Structure After Setup

```
/gc-proto/gcds-monorepo
├── apps/gcds.test.canada.ca/          # Development environment
├── packages/
│   ├── gcds-examples/          # Cloned fork repository
│   ├── gcds-components/        # Cloned fork repository
│   └── gcds-shortcuts/         # Cloned fork repository
└── [configuration files]
```

The GitHub Actions workflows in each fork repository will automatically sync with upstream daily.

## Development

### Start Development

```bash
pnpm dev  # Starts 11ty with live reload
```

### Create New Examples

1. Add templates to `apps/gcds.test.canada.ca/src/templates/english/` or `apps/gcds.test.canada.ca/src/templates/french/`
2. Use the base layout and include GC Design System components
3. Run `pnpm build` to generate HTML artifacts
4. Check results in `packages/gcds-examples/templates/`

### Contribute Changes

1. **Sync fork:**
   ```bash
   cd packages/gcds-examples
   git pull origin main
   ```

2. **Create feature branch:**
   ```bash
   git checkout -b feature/new-example
   ```

3. **Build and commit artifacts:**
   ```bash
   # From monorepo root
   pnpm build
   
   # From packages/gcds-examples
   git add templates/english/my-new-example.html
   git commit -m "feat(examples): add new example for [feature]"
   git push origin feature/new-example
   ```

4. **Open PR:** Create PR from your fork branch to upstream main

## Troubleshooting

- **Build errors**: Check that all dependencies are installed with `pnpm install`
- **Missing artifacts**: Ensure 11ty output directory is correctly configured
- **Sync issues**: Manually trigger GitHub Actions or check repository permissions
