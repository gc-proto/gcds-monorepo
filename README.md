# GC Proto Monorepo - Developer Contribution Hub

This monorepo provides a unified development environment for contributing to the GC Design System repositories. It uses pnpm workspaces to manage local development and streamlines the submission of flat HTML artifacts.

## Quick Start

1. **Install dependencies:**
   ```bash
   pnpm install
   ```

2. **Start development server:**
   ```bash
   pnpm dev
   ```

3. **Build artifacts:**
   ```bash
   pnpm build
   ```

## Architecture Overview

### Directory Structure
```
/gc-proto/gcds-monorepo
├── apps/
│   └── gcds.test.canada.ca/       # Eleventy development site
├── packages/
│   ├── gcds-components/    # Fork of cds-snc/gcds-components
│   ├── gcds-examples/      # Fork of cds-snc/gcds-examples
│   └── gcds-shortcuts/     # Fork of cds-snc/gcds-shortcuts
└── README.md
```

### Key Features

- **pnpm Workspaces**: Efficient dependency management and local linking
- **Eleventy Integration**: Builds templates into flat HTML artifacts
- **Automated Sync**: GitHub Actions keep forks up-to-date with upstream
- **Direct Output**: Generated HTML goes directly to `packages/gcds-examples/templates/`

## Development Workflow

1. **Local Development**: Work on Nunjucks templates in `apps/gcds.test.canada.ca/src/`
2. **Build**: Run `pnpm build` to generate HTML artifacts
3. **Review**: Check generated files in `packages/gcds-examples/templates/`
4. **Contribute**: Create PR from fork to upstream repository

## Scripts

- `pnpm dev` - Start development server with live reload
- `pnpm build` - Build templates to HTML artifacts
- `pnpm serve` - Serve built files locally

## Contributing

See `architecture.md` for detailed contribution workflow and setup instructions.
