return {
  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
  },

  -- automatically install LSPs to stdpath for neovim
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = false,
  },

  -- LSP configuration & plugins
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "lukas-reineke/lsp-format.nvim"
    },
    config = function()
      require("plugins.lsp.config")
    end
  },

  -- wrapper around LSP formatting
  {
    "lukas-reineke/lsp-format.nvim",
    lazy = true,
  },

  -- manage global and project-local settings
  {
    "folke/neoconf.nvim",
    event = "VeryLazy"
  },

  -- schema store
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}
