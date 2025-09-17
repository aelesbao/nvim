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
  -- Color picker and highlighter
  {
    "uga-rosa/ccc.nvim",
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
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
      { "<leader>ct", ":Trouble todo toggle<cr>",                     desc = "Open TODO list", },
      { "<leader>xx", ":Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)", },
      { "<leader>xX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", },
      { "<leader>xq", ":Trouble quickfix toggle<cr>",                 desc = "Quickfix (Trouble)" },
      { "<leader>xl", ":Trouble loclist toggle<cr>",                  desc = "Location list (Trouble)" },
      { "<leader>es", ":Trouble symbols toggle<cr>",                  desc = "Document symbols (Trouble)" },
      { "grr",        ":Trouble lsp_references<cr>",                  desc = "References (Trouble)" },
      { "grd",        ":Trouble lsp_definitions<cr>",                 desc = "Definitions (Trouble)" },
      { "gri",        ":Trouble lsp_implementations<cr>",             desc = "Implementations (Trouble)" },
      { "grt",        ":Trouble lsp_type_definitions<cr>",            desc = "Type definitions (Trouble)" },
    },
    ---@type trouble.Config
    opts = {
      auto_preview = false, -- automatically open preview when on an item
      auto_close = true,    -- auto close when there are no items
      auto_jump = true,     -- auto jump to the item when there's only one
      focus = true,         -- focus the window when opened

      ---@type trouble.Window.opts
      win = {}, -- window options for the results window. Can be a split or a floating window.

      -- Window options for the preview window. Can be a split, floating window,
      -- or `main` to show the preview in the main editor window.
      ---@type trouble.Window.opts
      preview = {
        type = "float"
      },
      ---@type table<string, trouble.Mode>
      modes = {
        symbols = {
          focus = true,
          win = {
            position = "right",
            size = { width = 50 },
          },
        },
      },
      icons = {
        ---@type trouble.Indent.symbols
        indent = {
          last = "╰╴", -- rounded
        },
      },
    },
  },

  -- fancy-looking tabs with filetype icons and close buttons
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
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
      "folke/tokyonight.nvim",
      "SmiteshP/nvim-navic",
      "AndreM222/copilot-lualine",
    },
    event = "VeryLazy",
    opts = function()
      local colors = require("tokyonight.colors").setup()

      return {
        options = {
          theme = "tokyonight",
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
                    enabled = colors.green,
                    disabled = colors.comment,
                    warning = colors.yellow,
                    unknown = colors.red,
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
          "avante",
          "fugitive",
          "lazy",
          "mason",
          "neo-tree",
          "quickfix",
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

  -- extensible UI for Neovim notifications and LSP progress messages
  {
    "j-hui/fidget.nvim",
    tag = "v1.6.1",
    opts = {
      -- Options related to notification subsystem
      notification = {
        -- Options related to the notification window and buffer
        window = {
          winblend = 90,       -- Background color opacity in the notification window
          border = "rounded",  -- Border around the notification window
          align = "bottom",    -- How to align the notification window
          relative = "editor", -- What the notification window position is relative to
        },
      },
    },
  },

  -- a collection of small QoL plugins for Neovim.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- TODO: replace more plugins and enable feats here
      bigfile = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = {
        enabled = vim.fn.executable("lazygit") == 1
      },
      picker = { enabled = true },
      rename = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
      dim = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
  },

  -- A framework for building Neovim plugins
  {
    "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
      panel = {
        panel_size = 30,
      },
    },
    config = function(_, opts)
      require("litee.lib").setup(opts)
    end
  },

  -- Neovim's missing call hierarchy UI
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
      },
    },
    event = "VeryLazy",
    opts = {
      on_open = "panel",
      map_resize_keys = false,
    },
    config = function(_, opts)
      require("litee.calltree").setup(opts)
    end
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
