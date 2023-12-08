-- Plugins listed here are generic enough and require minimal configuration
-- or are dependencies to other plugins.

return {
  -- detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- pairs of handy bracket mappings
  "tpope/vim-unimpaired",

  -- autopair that allows custom rules
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- add/change/delete surrounding delimiter pairs with ease
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
  },

  -- Smart comments
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {
      -- LHS of toggle mappings in NORMAL mode
      toggler = {
        line  = "<leader>cc", -- Line-comment toggle keymap
        block = "<leader>cb", -- Block-comment toggle keymap
      },
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line  = "<leader>cC", -- Line-comment keymap
        block = "<leader>cB", -- Block-comment keymap
      },
      -- LHS of extra mappings
      extra = {
        above = "<leader>cO", -- Add comment on the line above
        below = "<leader>co", -- Add comment on the line below
        eol   = "<leader>cA", -- Add comment at the end of line
      },
    },
  },

  -- beautitul icons used by other plugins
  "nvim-tree/nvim-web-devicons",

  -- shows color previews
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
      { "<leader>eu", vim.cmd.UndotreeToggle, desc = "Undotree" }
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
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
    enabled = vim.fn.executable("lazygit") == 1,
    keys = {
      { "<leader>gg", ":LazyGitCurrentFile<CR>", desc = "Lazygit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

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

  -- navigate between vim and tmux panes easily
  {
    "christoomey/vim-tmux-navigator",
    enabled = vim.fn.executable("tmux") == 1,
    keys = {
      { "<M-h>", ":TmuxNavigateLeft<cr>",      noremap = true, silent = true },
      { "<M-j>", ":TmuxNavigateDown<cr>",      noremap = true, silent = true },
      { "<M-k>", ":TmuxNavigateUp<cr>",        noremap = true, silent = true },
      { "<M-l>", ":TmuxNavigateRight<cr>",     noremap = true, silent = true },
      { "<M-;>", ":TmuxNavigatePrevious<cr>",  noremap = true, silent = true },
    },
    init = function()
      -- write all buffers before navigating from Vim to tmux pane
      vim.g.tmux_navigator_save_on_switch = 2
      -- disable tmux navigator when zooming the Vim pane
      vim.g.tmux_navigator_disable_when_zoomed = 1
      -- don't wrap around to the opposite side when moving past the edge of the screen
      vim.g.tmux_navigator_no_wrap = 1
      -- define custom navigation mapping
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>e"] = { name = "+explorer" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
