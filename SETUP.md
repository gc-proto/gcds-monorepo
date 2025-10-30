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

### 2. Clone Fork Repositories
The monorepo structure includes placeholder directories for the three fork repositories. Clone them into the packages directory:

```bash
# Navigate to packages directory
cd packages

# Remove placeholder directories and clone the three fork repositories
rm -rf gcds-examples gcds-components gcds-shortcuts
git clone https://github.com/gc-proto/gcds-examples.git gcds-examples
git clone https://github.com/gc-proto/gcds-components.git gcds-components  
git clone https://github.com/gc-proto/gcds-css-shortcuts.git gcds-shortcuts

# Return to monorepo root
cd ..

# Install all dependencies and link workspaces
pnpm install
```

### 3. Verify Setup
```bash
# Test the build process
pnpm build

# Start development server  
pnpm dev
```

## Development Workflow

### Repository Structure After Setup

```
/gc-proto/gcds-monorepo
├── apps/11ty-preview/          # Development environment
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

1. Add templates to `apps/11ty-preview/src/templates/english/` or `apps/11ty-preview/src/templates/french/`
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
