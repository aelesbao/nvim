-- Plugins that change / improve the editor's UI

local function diff_source()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

return {
  -- paints the background to shows color previews
  {
    "norcalli/nvim-colorizer.lua",
    opts = {
      "*",
    },
    config = function(_, opts) require("colorizer").setup(opts) end,
  },

  -- undo history visualizer
  {
    "mbbill/undotree",
    keys = {
      {
        "<leader>eu",
        function()
          vim.cmd.UndotreeToggle()
          vim.cmd.UndotreeFocus()
        end,
        desc = "Undotree",
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "┆",
      },
      scope = {
        show_start = true,
        show_end = false,
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)

      local theme = require("catppuccin.palettes").get_palette()
      vim.api.nvim_set_hl(0, "@ibl.scope.underline.1", { sp = theme.overlay1, underline = true })
    end
  },

  -- a pretty list for showing diagnostics, references, telescope results,
  -- quickfix and location lists to help you solve all the trouble your code is
  -- causing.
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>xx", ":TroubleToggle<cr>",                       desc = "Show diagnostics" },
      { "<leader>xw", ":TroubleToggle workspace_diagnostics<cr>", desc = "Show workspace diagnostics" },
      { "<leader>xd", ":TroubleToggle document_diagnostics<cr>",  desc = "Show document diagnostics" },
      { "<leader>xq", ":TroubleToggle quickfix<cr>",              desc = "Show quickfix" },
      { "<leader>xl", ":TroubleToggle loclist<cr>",               desc = "Show location list" },
    },
    opts = {
      icons = true,
      auto_close = true,           -- automatically close the list when you have no diagnostics
      use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
    },
  },

  -- fancy-looking tabs with filetype icons and close buttons
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      { "catppuccin/nvim", name = "catppuccin", lazy = false },
    },
    keys = {
      { "<leader>bp", ":BufferLineTogglePin<cr>",            desc = "Toggle pin" },
      { "<leader>bP", ":BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned tabs" },
      { "<leader>bo", ":BufferLineCloseOthers<cr>",          desc = "Delete other tabs" },
      { "<M-[>",      ":BufferLineCyclePrev<cr>",            desc = "Previous tab" },
      { "<M-]>",      ":BufferLineCycleNext<cr>",            desc = "Next tab" },
    },
    opts = function()
      local close_cmd = function(n) require("mini.bufremove").delete(n, false) end

      return {
        options = {
          mode = "tabs", -- or buffers
          themable = true,
          highlights = require("catppuccin.groups.integrations.bufferline").get(),
          close_command = close_cmd,
          right_mouse_command = close_cmd,
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          show_tab_indicators = true,
          -- separator_style = "slant", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          diagnostics_indicator = function(_, _, diag)
            local icons = {
              Error = " ",
              Warn = " ",
              Hint = " ",
              Info = " ",
            }
            local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                .. (diag.warning and icons.Warn .. diag.warning or "")
            return vim.trim(ret)
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File explorer",
              text_align = "left",
              highlight = "Directory",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
    end,
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "SmiteshP/nvim-navic",
      "AndreM222/copilot-lualine",
    },
    event = "VeryLazy",
    opts = function()
      local theme = require("catppuccin.palettes").get_palette()
      return {
        options = {
          theme = "catppuccin",
          icons_enabled = true,
          globalstatus = true,
          -- component_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          disabled_filetypes = {
            winbar = {
              "help",
              "neo-tree",
              "NvimTree",
              "undotree",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "b:gitsigns_head", icon = "" },
            { "diff", source = diff_source },
            "diagnostics"
          },
          lualine_c = { "filename" },
          lualine_x = {
            {
              "copilot",
              symbols = {
                status = {
                  hl = {
                    enabled = theme.green,
                    disabled = theme.subtext0,
                    warning = theme.yellow,
                    unknown = theme.red,
                  },
                },
              },
              show_colors = true,
              show_loading = true,
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        winbar = {
          lualine_c = {
            { "filename", path = 1, color = { bg = "NONE" } },
            {
              "navic",

              -- Component specific options
              -- Can be nil, "static" or "dynamic". This option is useful only when
              -- you have highlights enabled. Many colorschemes don't define same
              -- backgroud for nvim-navic as their lualine statusline backgroud.
              -- Setting it to "static" will perform a adjustment once when the
              -- component is being setup. This should be enough when the lualine
              -- section isn't changing colors based on the mode.
              -- Setting it to "dynamic" will keep updating the highlights according
              -- to the current modes colors for the current section.
              color_correction = nil,

              -- lua table with same format as setup's option. All options except
              -- "lsp" options take effect when set here.
              navic_opts = nil,
            },
          },
        },
        inactive_winbar = {
          lualine_c = {
            { "filename", path = 1, color = { bg = "NONE" } },
          },
        },
        extensions = {
          "lazy",
          "mason",
          "trouble",
        },
      }
    end,
  },

  -- code navigation bar / breadcrumbs
  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      highlight = true,
      click = true,
      separator = " › ",
      -- VScode-like icons
      icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      },
    },
    config = function(_, opts)
      require("nvim-navic").setup(opts)

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.api.nvim_buf_line_count(0) > 1000 then
            ---@diagnostic disable-next-line: inject-field
            vim.b.navic_lazy_update_context = true
          end
        end,
      })
    end,
  },

  -- notification pop-ups
  {
    "rcarriga/nvim-notify",
    dependencies = {
      { "catppuccin/nvim", name = "catppuccin" },
    },
    opts = function()
      local theme = require("catppuccin.palettes").get_palette()
      return {
        background_colour = theme.crust,
      }
    end,
    config = function(_, opts)
      vim.notify = require("notify")
      vim.notify.setup(opts)
    end,
  },

  -- improves the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    opts = {
      default_prompt = ">",
    },
  },

  -- dims inactive portions of the code you're editing using TreeSitter
  {
    "folke/twilight.nvim",
    opts = function()
      local theme = require("catppuccin.palettes").get_palette()
      return {
        dimming = {
          alpha = 0.25, -- amount of dimming
          -- we try to get the foreground from the highlight groups or fallback color
          color = { "Normal", theme.text },
          term_bg = theme.mantle, -- if guibg=NONE, this will be used to calculate text color
          inactive = true,        -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 50,             -- amount of lines we will try to show around the current line
      }
    end,
  },

  -- distraction-free coding
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>zz", ":ZenMode<CR>", desc = "Zen mode" },
    },
    opts = {
      window = {
        options = {
          signcolumn = "yes",
          number = true,
          cursorline = true,
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true },
        -- tmux = { enabled = true },
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        kitty = {
          enabled = true,
          font = "+4", -- font size increment
        },
        -- this will change the font size on alacritty when in zen mode
        -- requires  Alacritty Version 0.10.0 or higher
        -- uses `alacritty msg` subcommand to change font size
        alacritty = {
          enabled = true,
          font = "16", -- font size
        },
        -- this will change the font size on wezterm when in zen mode
        -- See alse also the Plugins/Wezterm section in this projects README
        wezterm = {
          enabled = true,
          -- can be either an absolute font size or the number of incremental steps
          font = "+4", -- (10% increase per step)
        },
      }
    },
  },
}
