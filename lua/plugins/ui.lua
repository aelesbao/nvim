-- Plugins that change / improve the editor's UI

return {
  -- paints the background to shows color previews
  {
    "norcalli/nvim-colorizer.lua",
    opts = {
      "*";
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end
  },

  -- undo history visualizer
  {
    "mbbill/undotree",
    keys = {
      { "<leader>eu", function()
        vim.cmd.UndotreeToggle()
        vim.cmd.UndotreeFocus()
      end, desc = "Undotree" }
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "┆",
      },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = true,
      yadm = {
        enable = false
      },
    },
  },

  -- calls lazygit from within nvim
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", ":LazyGitCurrentFile<CR>", desc = "Lazygit" },
    },
    enabled = vim.fn.executable("lazygit") == 1,
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
      { "<leader>xx", "<cmd>TroubleToggle",                       desc = "Show diagnostics" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics", desc = "Show workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics",  desc = "Show document diagnostics" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix",              desc = "Show quickfix" },
      { "<leader>xl", "<cmd>TroubleToggle loclist",               desc = "Show location list" },
      { "gR",         "<cmd>TroubleToggle lsp_references",        desc = "Show LSP references" },
    },
    opts = {
    },
  },

  -- fancy-looking tabs with filetype icons and close buttons
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      { "catppuccin/nvim", name = "catppuccin", }
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        mode = "buffers", -- or tabs
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = {
            Error = " ",
            Warn  = " ",
            Hint  = " ",
            Info  = " ",
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
    },
    config = function(_, opts)
      -- merge theme opts
      vim.tbl_deep_extend("force", opts, {
        highlights = require("catppuccin.groups.integrations.bufferline").get()
      })

      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left="", right="" },
        section_separators = { left="", right="" },
        disabled_filetypes = {
          statusline = {
            "dashboard",
            "NvimTree",
            "help",
            "undotree",
          },
          winbar = {
            "NvimTree",
            "help",
            "undotree",
          },
        },
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
            navic_opts = nil
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
        "nvim-tree",
        "trouble",
      },
    },
  },

  -- code navigation bar / breadcrumbs
  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig"
    },
    opts = {
      highlight = true,
      separator = ' › ',
      -- VScode-like icons
      icons = {
        File = ' ',
        Module = ' ',
        Namespace = ' ',
        Package = ' ',
        Class = ' ',
        Method = ' ',
        Property = ' ',
        Field = ' ',
        Constructor = ' ',
        Enum = ' ',
        Interface = ' ',
        Function = ' ',
        Variable = ' ',
        Constant = ' ',
        String = ' ',
        Number = ' ',
        Boolean = ' ',
        Array = ' ',
        Object = ' ',
        Key = ' ',
        Null = ' ',
        EnumMember = ' ',
        Struct = ' ',
        Event = ' ',
        Operator = ' ',
        TypeParameter = ' ',
      }
    },
  },

  -- notification pop-ups
  {
    "rcarriga/nvim-notify",
    opts = {
      -- whether or not to position the notifications at the top or not
      top_down = false,
      background_colour = "#181926",
    },
    config = function(_, opts)
      vim.notify = require("notify")
      vim.notify.setup(opts)
    end
  },

  -- improves the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    opts = {
      default_prompt = ">"
    },
  }
}
