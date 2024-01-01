-- Context aware auto-completion and snippet plugins

return {
  -- auto-completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- extend nvim-cmp with additional sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",

      -- snippet engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      -- adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",

      -- Add Lua GitHub copilot as a completion source
      "zbirenbaum/copilot-cmp",

      -- vscode-like pictograms for neovim lsp completion items
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",

      -- convetional commits
      "davidsierradz/cmp-conventionalcommits",

      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      require("plugins.cmp.config")
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    opts = {},
    config = function(_, opts)
      local luasnip = require("luasnip")

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      -- lua format
      require("luasnip.loaders.from_lua").load()

      luasnip.config.setup(opts)
    end,
  },

  -- adds LSP completion capabilities
  {
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end,
  },

  -- GitHub copilot in Lua
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    ---@type copilot_config
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<Tab>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-e>",
        },
      },
      filetypes = {
        yaml = true,
        plaintext = false,
      },
    },
  },
}
