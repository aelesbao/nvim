return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    ---@type CatppuccinOptions
    opts = {
      flavour = "macchiato",         -- latte, frappe, macchiato, mocha
      transparent_background = true, -- disables setting the background color.
      dim_inactive = {
        enabled = true,              -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.25,           -- percentage of the shade to apply to the inactive window
      },
      integrations = {
        cmp = true,
        bufferline = true,
        dashboard = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = {
          enabled = true,
          scope_color = "subtext0",
        },
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
        navic = {
          enabled = true,
          custom_bg = "NONE", -- "lualine" will set background to mantle
        },
        neotree = true,
        notify = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        window_picker = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      vim.cmd.colorscheme "catppuccin-macchiato"
      require("catppuccin").setup(opts)
    end,
  },

  -- enables transparent background
  {
    "xiyaowong/transparent.nvim",
    lazy = false, -- make sure we load this during startup
    dependencies = {
      { "catppuccin/nvim", name = "catppuccin", }
    },
  }
}
