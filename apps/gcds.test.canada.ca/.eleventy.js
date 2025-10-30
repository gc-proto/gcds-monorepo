module.exports = function(eleventyConfig) {
  // Copy static assets
  eleventyConfig.addPassthroughCopy("src/assets");
  
  // CRITICAL: Collection Filtering Logic
  // Filter out .njk files from collections to prevent them from being output as final HTML artifacts
  eleventyConfig.addCollection("englishTopics", function(collection) {
    return collection.getFilteredByGlob("templates/english/**/*")
      .filter(item => !item.inputPath.endsWith('.njk'));
  });

  eleventyConfig.addCollection("frenchTopics", function(collection) {
    return collection.getFilteredByGlob("templates/french/**/*")
      .filter(item => !item.inputPath.endsWith('.njk'));
  });
  
  // Watch for changes in local packages
  eleventyConfig.addWatchTarget("../../packages/gcds-components/");
  eleventyConfig.addWatchTarget("../../packages/gcds-shortcuts/");
  
  // Set directories
  return {
    dir: {
      input: "src",
      output: "../../packages/gcds-examples/templates",
      includes: "_includes",
      data: "_data"
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    templateFormats: ["md", "njk", "html"]
  };
};
