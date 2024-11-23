return {
  {
    "mustache/vim-mustache-handlebars",
    ft = { "handlebars", "mustache" },
  },

  {
    "fladson/vim-kitty",
    ft = { "kitty" },
  },

  {
    "0xmovses/move.vim",
    ft = { "move" },
  },

  { import = "plugins.languages.helm" },
  { import = "plugins.languages.lua" },
  { import = "plugins.languages.rust" },
}
