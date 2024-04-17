---@param colors CtpColors<string>
local function build_level_colors(colors)
  return {
    ok = colors.green,
    hint = colors.teal,
    info = colors.sky,
    warn = colors.yellow,
    error = colors.red,
  }
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    ---@type CatppuccinOptions
    opts = {
      flavour = "mocha",             -- latte, frappe, macchiato, mocha
      transparent_background = true, -- disables setting the background color.
      dim_inactive = {
        enabled = true,              -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.25,           -- percentage of the shade to apply to the inactive window
      },
      integrations = {
        alpha = true,
        bufferline = true,
        cmp = true,
        dap = true,
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
        },
        navic = {
          enabled = true,
          custom_bg = "NONE", -- "lualine" will set background to mantle
        },
        neotest = true,
        neotree = true,
        notify = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        window_picker = true,
        which_key = true,
      },
      highlight_overrides = {
        all = function(colors)
          local level_colors = build_level_colors(colors)
          return {
            DiagnosticOk = { fg = level_colors.ok, style = { "italic" } },
            DiagnosticHint = { fg = level_colors.hint, style = { "italic" } },
            DiagnosticInfo = { fg = level_colors.info, style = { "italic" } },
            DiagnosticWarn = { fg = level_colors.warn, style = { "italic" } },
            DiagnosticError = { fg = level_colors.error, style = { "italic" } },
          }
        end
      }
    },
    config = function(_, opts)
      -- vim.g.catppuccin_debug = true
      vim.cmd.colorscheme("catppuccin-" .. opts.flavour)
      require("catppuccin").setup(opts)

      local colors = require("catppuccin.palettes").get_palette()
      local level_colors = build_level_colors(colors)

      -- TODO: fix highlight overrides
      local h = vim.api.nvim_set_hl
      h(0, "DiagnosticUnderlineOk", { undercurl = true, sp = level_colors.ok })
      h(0, "DiagnosticUnderlineHint", { undercurl = true, sp = level_colors.hint })
      h(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = level_colors.info })
      h(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = level_colors.warn })
      h(0, "DiagnosticUnderlineError", { undercurl = true, sp = level_colors.error })
      h(0, "LspDiagnosticsUnderlineHint", { undercurl = true, sp = level_colors.hint })
      h(0, "LspDiagnosticsUnderlineInformation", { undercurl = true, sp = level_colors.info })
      h(0, "LspDiagnosticsUnderlineWarning", { undercurl = true, sp = level_colors.warn })
      h(0, "LspDiagnosticsUnderlineError", { undercurl = true, sp = level_colors.error })
    end,
  },

  -- enables transparent background
  {
    "xiyaowong/transparent.nvim",
    lazy = false, -- make sure we load this during startup
    dependencies = {
      { "catppuccin/nvim", name = "catppuccin" },
    },
    opts = {
      exclude_groups = {
        "CursorLine",
      },
    },
  },
}
