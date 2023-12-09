return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("plugins.lsp.config")
    end
  },

    -- LSP configuration & plugins
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- automatically install LSPs to stdpath for neovim
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- setup for init.lua and plugin development with full signature help,
      -- docs and completion for the nvim lua API
      { "folke/neodev.nvim", opts = {} },
    },
    config = false,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    config = false,
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

  -- manage global and project-local settings
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    dependencies = {
      "nvim-lspconfig"
    },
    config = false,
  },
}
