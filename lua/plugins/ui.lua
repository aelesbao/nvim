-- Plugins that change / improve the editor's UI

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
    ---@module "trouble"
    ---@type trouble.Config
    opts = {
      auto_preview = false, -- automatically open preview when on an item
      auto_close = true,    -- auto close when there are no items
      auto_jump = true,     -- auto jump to the item when there's only one
      focus = true,         -- focus the window when opened

      ---@module "trouble"
      ---@type trouble.Window.opts
      win = {}, -- window options for the results window. Can be a split or a floating window.

      -- Window options for the preview window. Can be a split, floating window,
      -- or `main` to show the preview in the main editor window.
      ---@module "trouble"
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
}
