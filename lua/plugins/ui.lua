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

  -- TODO nice tab line

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = {
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        disabled_filetypes = {
          statusline = {
            "NvimTree",
            "help",
            "undotree",
          },
          winbar = {
            "NvimTree",
            "help",
            "undotree",
          }
        },
      },
    },
  },

  -- notification pop-ups
  {
    "rcarriga/nvim-notify",
    opts = {
      -- whether or not to position the notifications at the top or not
      top_down = false
    },
    config = function(_, opts)
      vim.notify = require("notify")
      vim.notify.setup(opts)
    end
  },
}
