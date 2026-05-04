# gcds-srvinfo Component Implementation

## Overview
The `gcds-srvinfo` component is a Stencil web component that displays a "Services and Information" section commonly found on GC topic and institutional landing pages. It provides a flexible, responsive grid layout for displaying service links with descriptions with full bilingual support.

## Features Implemented

### 1. Configurable Number of Items (1-9)
- **Prop**: `items` (default: 9, type: number)
- Dynamically controls how many service items are displayed
- Validates input to ensure values stay between 1 and 9 using `@Watch` decorator
- Automatically clamps values outside the valid range

### 2. Heading Visibility Control
- **Prop**: `headingVisible` (default: false, type: boolean)
- When `false`: heading uses `visibility-sr-only` class (hidden visually, accessible to screen readers)
- When `true`: heading is fully visible

### 3. Flexible Column Layout
- **Prop**: `columns` (default: true, type: boolean)
- When `false`: displays 1 column layout
- When `true`: displays 3 column layout
- Automatically adjusts for responsive breakpoints:
  - Mobile: Always 1 column
  - Tablet: 1 or 2 columns (based on columns prop)
  - Desktop: 1 or 3 columns (based on columns prop)

### 4. Bilingual Heading Support
- **Implementation**: i18n system with language detection
- Heading text automatically switches based on component's `lang` attribute:
  - English: "Services and information"
  - French: "Services et renseignements"
- Uses MutationObserver to watch for language changes
- Falls back to English if language is not recognized

### 5. Banded Background Option
- **Prop**: `banded` (default: false, type: boolean)
- When `true`: applies banding background to the section
- Supports visual hierarchy on pages

### 6. Dynamic Service Items
- **Prop**: `serviceItems` (type: Array<ServiceItem> | string, default: '[]')
- Accepts either an array of objects or a JSON string
- Each item contains:
  - `linkText`: The link text to display (required)
  - `linkHref`: The URL for the link (required)
  - `description`: Description text below the link (required)
- Validates that all items have required properties
- Filters out invalid items automatically
- Tracks validation errors in component state

### 7. Default Slot
- **Slot**: `default` - Allows additional doormat content to be added after the grid
- Provides flexibility for custom content insertion

## Technical Implementation

### Component Structure
```
gcds-srvinfo/
├── gcds-srvinfo.tsx      # Component logic
├── gcds-srvinfo.css      # Component styles
├── i18n/
│   ├── i18n.js          # Bilingual string definitions
│   └── i18n.d.ts        # TypeScript declarations for i18n
├── README.md             # Auto-generated documentation
└── IMPLEMENTATION.md     # This file
```

### TypeScript Interface
```typescript
export interface ServiceItem {
  linkText: string;
  linkHref: string;
  description: string;
}
```

### State Management
- **`lang`**: Tracks current language (en/fr), initialized in `componentWillLoad`
- **`errors`**: Array tracking validation errors for props

### Dependencies
The component leverages existing GCDS components and shortcuts:
- `gcds-container` - Container component with size control
- `gcds-grid` - Responsive grid layout
- `gcds-link` - Accessible link component
- GCDS CSS shortcuts for styling (typography, spacing, visibility)

### Responsive Behavior
The component uses the `gcds-grid` component's responsive properties:
- `columns="1"` - Mobile (all breakpoints below tablet)
- `columns-tablet="..."` - Tablet breakpoint
- `columns-desktop="..."` - Desktop breakpoint

### Styling Approach
Uses GCDS CSS shortcuts exclusively:
- `font-size-h3` - Heading typography
- `font-family-heading` - Heading font family
- `font-bold` - Bold text weight
- `font-size-text-small` - Small text size
- `mt-400`, `mb-400` - Margin spacing
- `visibility-sr-only` - Screen reader only visibility
- `lg:mb-200`, `xs:mb-0` - Responsive margins

### Shadow DOM
The component uses Shadow DOM (`shadow: true`) for encapsulation, which:
- Prevents style leakage
- Ensures consistent rendering
- Maintains component isolation

### Validation System
The component implements comprehensive prop validation:
- **`@Watch('items')`**: Validates and clamps items to 1-9 range
- **`@Watch('columns')`**: Validates column prop (currently accepts boolean)
- **`@Watch('serviceItems')`**: 
  - Parses JSON strings into objects
  - Validates array structure
  - Checks each item for required properties
  - Filters out invalid items
  - Tracks errors in state
- **`validateRequiredProps()`**: Runs all validations before render
- **`logError()`**: Logs validation errors to console

### Language Management
- Uses `assignLanguage()` utility to detect language from element or document
- Implements MutationObserver via `updateLang()` to watch for lang attribute changes
- i18n system provides bilingual strings
- Heading getter method ensures type-safe language selection

## Usage Examples

### Basic Usage (JavaScript Array)
```html
<gcds-srvinfo id="services" items="6" columns heading-visible lang="en"></gcds-srvinfo>

<script>
  const services = [
    {
      linkText: "Employment Insurance",
      linkHref: "#",
      description: "Get financial help if you lose your job"
    },
    {
      linkText: "Taxes",
      linkHref: "#",
      description: "File your taxes and get tax information"
    },
    // ... more items
  ];
  
  document.getElementById('services').serviceItems = services;
</script>
```

### Using JSON String
```html
<gcds-srvinfo 
  items="3" 
  heading-visible
  service-items='[
    {"linkText":"Health","linkHref":"#","description":"Health services and benefits"},
    {"linkText":"Travel","linkHref":"#","description":"Travel advice and passports"},
    {"linkText":"Business","linkHref":"#","description":"Business grants and financing"}
  ]'>
</gcds-srvinfo>
```

### French Language
```html
<gcds-srvinfo id="services-fr" items="6" columns heading-visible lang="fr"></gcds-srvinfo>

<script>
  document.getElementById('services-fr').serviceItems = [
    {
      linkText: "Assurance-emploi",
      linkHref: "#",
      description: "Obtenez de l'aide financière si vous perdez votre emploi"
    },
    // ... more items
  ];
</script>
```

### Single Column Layout
```html
<gcds-srvinfo items="3" heading-visible columns="false"></gcds-srvinfo>
<!-- Set columns to false for 1 column layout -->
```

### With Banded Background
```html
<gcds-srvinfo items="6" columns heading-visible banded></gcds-srvinfo>
```

### With Additional Content via Slot
```html
<gcds-srvinfo items="6" columns heading-visible>
  <div>
    <p>Additional information or doormat content can go here.</p>
  </div>
</gcds-srvinfo>
```

## Props Reference

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `items` | `number` | `9` | Number of service items to display (1-9) |
| `columns` | `boolean` | `true` | Column layout: false = 1 column, true = 3 columns |
| `headingVisible` | `boolean` | `false` | Controls heading visibility |
| `banded` | `boolean` | `false` | Applies banding background |
| `serviceItems` | `Array<ServiceItem> \| string` | `'[]'` | Array of service items or JSON string |

All props use `reflect: true` (except `serviceItems`) to reflect values to attributes for CSS selectors.

## Component Lifecycle

1. **componentWillLoad()**:
   - Assigns language using `assignLanguage()`
   - Sets up language observer with `updateLang()`
   - Validates all props with `validateRequiredProps()`
   - Logs any validation errors

2. **render()**:
   - Guards against rendering if validation fails
   - Calculates valid items to display
   - Converts serviceItems to array if needed
   - Renders grid with responsive columns
   - Displays heading with proper visibility class
   - Renders service items as links with descriptions
   - Includes default slot for additional content

## Testing
To test the component:
1. Build the component: `npm run build`
2. Start the Stencil dev server: `npm start`
3. View the component in the browser
4. Test with different prop combinations
5. Test language switching by changing the `lang` attribute
6. Test JSON string parsing for `serviceItems`
7. Test validation by providing invalid prop values

## Accessibility Considerations
- Heading is always present for screen readers (even when visually hidden with `visibility-sr-only`)
- Uses semantic HTML elements (`<h2>`, `<p>`)
- Leverages GCDS components which have built-in accessibility features
- Proper heading hierarchy (h2 for section heading)
- Link descriptions provide context for screen reader users
- Bilingual support ensures content is accessible in both official languages
- Component uses `<Host>` wrapper for proper shadow DOM rendering

## GCDS Standards Compliance
This component follows the GCDS Component Development Specifications:
- ✅ Uses StencilJS with TypeScript
- ✅ Shadow DOM enabled
- ✅ All props documented with JSDoc
- ✅ Prop validation with `@Watch` decorators
- ✅ Language support with i18n
- ✅ State management for errors and language
- ✅ MutationObserver for language changes
- ✅ Guard clause pattern in render
- ✅ Comprehensive validation system
- ✅ Error logging with `logError()` utility
- ✅ TypeScript interfaces exported
- ✅ Supports both object and JSON string inputs
