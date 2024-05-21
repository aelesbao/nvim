return {
  {
    "mustache/vim-mustache-handlebars",
    ft = { "handlebars", "mustache" },
  },

  {
    "fladson/vim-kitty",
    ft = { "kitty" },
  },

  { import = "plugins.languages.helm" },
  { import = "plugins.languages.rust" },
}
