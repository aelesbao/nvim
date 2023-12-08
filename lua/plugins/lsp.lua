return {
  -- this is where your plugins related to LSP can be installed.
  {
    -- LSP configuration & plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  {
    -- autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",

      -- adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
  },
}
