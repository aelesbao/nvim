return {
  {
    "cuducos/yaml.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    ft = { "yaml" },
  },

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

  { import = "plugins.languages.go" },
  { import = "plugins.languages.helm" },
  { import = "plugins.languages.lua" },
  { import = "plugins.languages.rust" },
}
