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
    "HiPhish/jinja.vim",
  },

  {
    "fladson/vim-kitty",
    ft = { "kitty" },
  },

  {
    "bezhermoso/tree-sitter-ghostty",
    build = "make nvim_install",
  },

  {
    "isak102/ghostty.nvim",
    opts = {
      -- The autocmd pattern matched against the filename of the buffer. If this pattern
      -- matches, ghostty.nvim will run on save in that buffer. This pattern is passed to
      -- nvim_create_autocmd, check `:h autocmd-pattern` for more information. Can be
      -- either a string or a list of strings
      file_pattern = "*/ghostty/config",
      -- The ghostty executable to run.
      ghostty_cmd = "ghostty",
      -- The timeout in milliseconds for the check command.
      -- If the command takes longer than this it will be killed.
      check_timeout = 1000,
    },
  },

  { import = "plugins.languages.go" },
  { import = "plugins.languages.helm" },
  { import = "plugins.languages.lua" },
  { import = "plugins.languages.move" },
  { import = "plugins.languages.rust" },
}
