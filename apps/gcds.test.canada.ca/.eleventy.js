const path = require("path");

module.exports = function(eleventyConfig) {
  // Date filter for formatting dates - ensure this is properly registered
  eleventyConfig.addFilter("date", function(date, format) {
    if (!date) return "";
    const d = new Date(date);
    // Handle different format strings
    if (format === "YYYY-MM-DD") {
      return d.toISOString().split('T')[0];
    }
    if (format === "iso") {
      return d.toISOString().split('T')[0];
    }
    // Default to ISO date format (YYYY-MM-DD)
    return d.toISOString().split('T')[0];
  });

  // Passthrough copy for static assets if needed later
  eleventyConfig.addPassthroughCopy({ "templates/public": "/" });
  eleventyConfig.addPassthroughCopy("src/assets");

  // Collections: english and french
  eleventyConfig.addCollection("english", (collectionApi) => {
    return collectionApi.getFilteredByGlob("src/en/**/*.{html,njk,liquid,md}");
  });
  eleventyConfig.addCollection("french", (collectionApi) => {
    return collectionApi.getFilteredByGlob("src/fr/**/*.{html,njk,liquid,md}");
  });

  function groupByTopic(items, lang) {
    const groups = new Map();
    for (const item of items) {
      const input = item.inputPath || (item.data && item.data.page && item.data.page.inputPath) || "";
      // Expect paths like ./src/en/templates/<topic>/... or ./src/en/components/<topic>/...
      const parts = input.replace(/\\\\/g, "/").split("/");
      const langIdx = parts.indexOf(lang);
      // Get the folder after templates or components (the topic)
      const topic = langIdx > -1 && parts.length > langIdx + 2 ? parts[langIdx + 2] : "misc";
      if (!groups.has(topic)) groups.set(topic, []);
      groups.get(topic).push(item);
    }
    // Convert to array of { topic, items }
    return Array.from(groups.entries())
      .map(([topic, items]) => ({ topic, items }))
      .sort((a, b) => a.topic.localeCompare(b.topic));
  }

  eleventyConfig.addCollection("englishTopics", (collectionApi) => {
    const items = collectionApi.getFilteredByGlob("src/en/**/*.{html,njk,liquid,md}");
    return groupByTopic(items, "en");
  });
  eleventyConfig.addCollection("frenchTopics", (collectionApi) => {
    const items = collectionApi.getFilteredByGlob("src/fr/**/*.{html,njk,liquid,md}");
    return groupByTopic(items, "fr");
  });

  // Filter to build language switch link using page.data.langAltUrl
  eleventyConfig.addFilter("langSwitchHref", (page) => {
    if (page && page.data) {
      if (page.data.langAltAbsolute) return page.data.langAltAbsolute;
      if (page.data.langAltUrl) return page.data.langAltUrl;
    }
    return "#";
  });

  // Watch for changes in local packages
  eleventyConfig.addWatchTarget("../../packages/gcds-components/");
  eleventyConfig.addWatchTarget("../../packages/gcds-shortcuts/");

  // Clean URLs
  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data"
    },
    templateFormats: ["njk", "liquid", "html", "md"],
    htmlTemplateEngine: "njk",
    markdownTemplateEngine: "njk",
    pathPrefix: "/"
  };
};
