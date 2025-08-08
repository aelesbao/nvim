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

  -- Display LSP inlay hints at the end of the line, rather than within the line.
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {
      icons = {
        type = "󰜁 ",
        parameter = "󰏪 ",
        offspec = " ", -- hint kind not defined in official LSP spec
        unknown = " ", -- hint kind is nil
      },
      label = {
        truncateAtChars = 50,
        padding = 1,
        marginLeft = 0,
        sameKindSeparator = ", ",
      },
      extmark = {
        priority = 50,
      },
      autoEnableHints = true,
    },
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
