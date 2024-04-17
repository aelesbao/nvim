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

      -- snippet engine nvim-cmp source
      "saadparwaiz1/cmp_luasnip",
      -- adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",

      -- Add Lua GitHub copilot as a completion source
      "zbirenbaum/copilot-cmp",

      -- adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      -- vscode-like pictograms for neovim lsp completion items
      "onsails/lspkind.nvim",

      -- convetional commits
      "davidsierradz/cmp-conventionalcommits",

      "hrsh7th/cmp-nvim-lua",
    },
    config = function() require("plugins.completion.config") end,
  },

  -- snippet engine
  {
    "L3MON4D3/LuaSnip",
    opts = {},
    build = "make install_jsregexp",
    config = function(_, opts)
      local luasnip = require("luasnip")

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      -- lua format
      require("luasnip.loaders.from_lua").load()

      luasnip.config.setup(opts)
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
          accept = "<C-y>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-c>",
        },
      },
      filetypes = {
        yaml = true,
        plaintext = false,
      },
    },
  },
}
