# Institutional Landing Page Template

## Localization

This template uses a centralized localization approach with strings stored in JSON files following the format `{key: {en: value, fr: value}}`.

### Localization Data File

All translatable strings are stored in:
- `/src/_data/locales/institutionalLandingPage.json`

The JSON structure follows the pattern:
```json
{
  "contentHeader": {
    "en": "Institutional landing page",
    "fr": "Page d'accueil institutionnelle"
  },
  "introText": {
    "en": "The introduction block pattern introduces...",
    "fr": "La configuration de conception du bloc..."
  }
}
```

### Language Defaults

Language is set automatically based on folder structure:
- All files in `/src/en/` automatically get `lang: "en"` via `/src/en/en.json`
- All files in `/src/fr/` automatically get `lang: "fr"` via `/src/fr/fr.json`

No need to set `lang` in individual file frontmatter.

### Template Usage

The localization data is available globally as `t` (short for "translations").

Access strings using the notation: `{{ t.keyName[lang] }}`

Examples:
```nunjucks
<h1>{{ t.contentHeader[lang] }}</h1>
<p>{{ t.introText[lang] }}</p>

{# For nested objects #}
<h2>{{ t.featuredLink.srHeading[lang] }}</h2>

{# For arrays #}
{% for link in t.mostRequested.links[lang] %}
  <a href="#">{{ link }}</a>
{% endfor %}
```

### Benefits

1. **Single Source of Truth**: One JSON file contains all translations
2. **Simple Notation**: Use `key[lang]` instead of language-specific objects
3. **DRY Templates**: Both English and French templates share the same markup
4. **Auto Language Detection**: Language is set by folder structure
5. **Easy Maintenance**: Update strings in one place
6. **Scalable**: Easy to add new languages or string keys

### Adding New Strings

To add new translatable content:

1. Add the string to `/src/_data/locales/institutionalLandingPage.json`:
```json
{
  "yourNewKey": {
    "en": "English text",
    "fr": "Texte français"
  }
}
```

2. Reference it in the template using `{{ t.yourNewKey[lang] }}`

### Data Structure

The localization data is organized by page sections:
- `contentHeader`, `introText`, `superTaskButton` - Hero section
- `featuredLink` - Promotional banner
- `mostRequested` - Top tasks
- `servicesInfo` - Services and information section
- `contact` - Contact section
- `about` - About the institution
- `socialMedia` - Social media links
- `ministers` - Ministers section
- `news` - News items
- `features` - Featured content

Each key contains an object with `en` and `fr` properties for English and French translations.
