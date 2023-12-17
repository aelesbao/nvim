-- Plugins for text manipulation or that change the way the editor behaves

return {
  -- detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- pairs of handy bracket mappings
  "tpope/vim-unimpaired",

  -- autopair that allows custom rules
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      check_ts = true,
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- inserts `(` after select function or method item
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end
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
    event = "VeryLazy",
    opts = {
      -- LHS of toggle mappings in NORMAL mode
      toggler = {
        line  = "<leader>cc", -- Line-comment toggle keymap
        block = "<leader>cb", -- Block-comment toggle keymap
      },
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line  = "<leader>cc", -- Line-comment keymap
        block = "<leader>cb", -- Block-comment keymap
      },
      -- LHS of extra mappings
      extra = {
        above = "<leader>cO", -- Add comment on the line above
        below = "<leader>co", -- Add comment on the line below
        eol   = "<leader>cA", -- Add comment at the end of line
      },
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- navigate between vim and tmux panes easily
  {
    "christoomey/vim-tmux-navigator",
    enabled = vim.fn.executable("tmux") == 1,
    keys = {
      { "<M-h>", ":TmuxNavigateLeft<cr>",      silent = true },
      { "<M-j>", ":TmuxNavigateDown<cr>",      silent = true },
      { "<M-k>", ":TmuxNavigateUp<cr>",        silent = true },
      { "<M-l>", ":TmuxNavigateRight<cr>",     silent = true },
      { "<M-;>", ":TmuxNavigatePrevious<cr>",  silent = true },
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

  -- TODO: session manager
}
