# GC Proto Monorepo - Developer Contribution Hub

This monorepo provides a unified development environment for contributing to the GC Design System repositories. It uses pnpm workspaces to manage local development and streamlines the submission of flat HTML artifacts.

## Quick Start

1. **Clone and setup (first time only):**
   ```bash
   git clone https://github.com/gc-proto/gcds-monorepo.git
   cd gcds-monorepo
   ```
   **Then follow [SETUP.md](SETUP.md) to clone fork repositories**

2. **Install dependencies:**
   ```bash
   pnpm install
   ```

3. **Start development server:**
   ```bash
   pnpm dev
   ```

4. **Build artifacts:**
   ```bash
   pnpm build
   ```

## Architecture Overview

### Directory Structure
```
/gc-proto/gcds-monorepo
├── apps/
│   └── gcds.test.canada.ca/       # Eleventy development site
│       ├── _site/                 # Local build output (not committed)
│       └── src/
│           ├── en/                # English content
│           │   ├── templates/     # HTML templates -> gcds-examples/templates/english
│           │   └── components/    # Component examples -> gcds-components
│           ├── fr/                # French content
│           │   ├── templates/     # HTML templates -> gcds-examples/templates/french
│           │   └── components/    # Component examples -> gcds-components
│           ├── _includes/         # Nunjucks layouts and partials
│           └── _data/             # Global data files
├── packages/                      # Fork repositories (independent git repos)
│   ├── gcds-components/           # Fork of cds-snc/gcds-components (separate .git)
│   ├── gcds-examples/             # Fork of cds-snc/gcds-examples (separate .git)
│   └── gcds-shortcuts/            # Fork of cds-snc/gcds-shortcuts (separate .git)
├── scripts/
│   ├── contribute.sh              # Copies .html files to appropriate packages
│   └── setup-forks.sh             # Initial setup script for cloning forks
└── SETUP.md                       # Setup instructions for cloning forks
```

### Key Features

- **pnpm Workspaces**: Efficient dependency management and local linking
- **Eleventy Integration**: Builds templates into flat HTML artifacts in `_site/`
- **Build Separation**: Development builds stay local; only final `.html` files are copied to packages
- **Automated Sync**: GitHub Actions keep forks up-to-date with upstream
- **Dual Output Support**: Separate paths for templates (gcds-examples) and components (gcds-components)

## Development Workflow

1. **Local Development**: 
   - Create `.html` templates in `apps/gcds.test.canada.ca/src/en/templates/` or `src/fr/templates/`
   - Create `.html` component examples in `apps/gcds.test.canada.ca/src/en/components/` or `src/fr/components/`
   - Use `.njk` and `.md` files for navigation/development pages (won't be copied to packages)
2. **Build**: Run `pnpm build` to generate HTML artifacts in `_site/`
3. **Preview**: Review built files locally in `_site/`
4. **Contribute**: Run `pnpm contribute` to copy only original `.html` files to appropriate packages
5. **Submit**: Create PR from fork to upstream repository:
   ```bash
   # Navigate to the appropriate package
   cd packages/gcds-examples
   
   # Create a new branch for your changes
   git checkout -b feature/new-example
   
   # Stage and commit the generated HTML files
   git add templates/english/my-new-example.html
   git add templates/french/mon-nouvel-exemple.html
   git commit -m "feat(examples): add new example for [feature]"
   
   # Push to your fork
   git push origin feature/new-example
   
   # Open a PR on GitHub from:
   # gc-proto/gcds-examples:feature/new-example
   # to: cds-snc/gcds-examples:main
   ```

## Scripts

- `pnpm dev` - Start development server with live reload
- `pnpm build` - Build templates to HTML artifacts in `_site/`
- `pnpm serve` - Serve built files locally
- `pnpm contribute` - Copy only `.html` files from `_site/` to appropriate packages

## Contributing

**Important:** Each package in `packages/` is an independent git repository. Changes to packages are tracked and committed within their own repositories, not in the monorepo root.

When you make changes:
- The monorepo (gcds-monorepo) manages the development environment
- Each package (gcds-examples, gcds-components, gcds-shortcuts) tracks its own changes
- You commit and push from within each package directory

See `architecture.md` for detailed contribution workflow and setup instructions.
