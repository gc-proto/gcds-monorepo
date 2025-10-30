# 11ty Preview App

This Eleventy application consumes GC Design System components from the local packages and generates flat HTML artifacts for contribution to the upstream repositories.

## Key Configuration

- **Output Directory**: `../../packages/gcds-examples/templates/`
- **Input Directory**: `src/`
- **Template Engine**: Nunjucks

## Directory Structure

```
src/
├── _includes/          # Reusable template partials
├── _layouts/           # Page layouts
├── _data/              # Global data files
├── assets/             # Static assets
└── templates/
    ├── english/        # English template examples
    └── french/         # French template examples
```

## Development

1. **Start development server:**
   ```bash
   pnpm dev
   ```

2. **Create new templates:**
   - Add `.md` or `.njk` files to `src/templates/english/` or `src/templates/french/`
   - Use frontmatter to set layout, title, and permalink
   - Include GC Design System components in your templates

3. **Build artifacts:**
   ```bash
   pnpm build
   ```

## Critical Notes

- The `.eleventy.js` configuration filters out `.njk` files from final collections
- Built HTML files are output directly to the `gcds-examples` package
- Local package dependencies are linked via pnpm workspaces
