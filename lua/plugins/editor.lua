-- Plugins for text manipulation or that change the way the editor behaves

local function buf_wipeout()
  local bw = require("mini.bufremove").wipeout

  -- list of all buffer numbers
  local buffers = {}
  ---@diagnostic disable-next-line: param-type-mismatch
  for buf = 1, vim.fn.bufnr("$") do
    table.insert(buffers, buf)
  end

  -- save the current tab page
  local currentTab = vim.fn.tabpagenr()

  -- go through all tab pages
  for tab = 1, vim.fn.tabpagenr("$") do
    vim.cmd.tabnext(tab)

    -- go through all windows
    for win = 1, vim.fn.winnr("$") do
      -- whatever buffer is in this window in this tab, remove it from the buffers list
      local thisbuf = vim.fn.winbufnr(win)
      for i, buf in ipairs(buffers) do
        if buf == thisbuf then
          table.remove(buffers, i)
          break
        end
      end
    end
  end

  -- do not wipeout unlisted buffers
  for i = #buffers, 1, -1 do
    local buf = buffers[i]
    if vim.fn.getbufvar(buf, "&buflisted") == 0 or not vim.api.nvim_buf_is_valid(buf) then
      table.remove(buffers, i)
    end
  end

  -- delete the remaining buffers
  for _, buf in ipairs(buffers) do
    bw(buf)
  end

  -- go back to the original tab page
  vim.cmd.tabnext(currentTab)
  vim.notify(#buffers .. " hidden buffers wiped out")
end

return {
  -- detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- pairs of handy bracket mappings
  "tpope/vim-unimpaired",

  -- work with several variants of a word at once
  "tpope/vim-abolish",

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

  -- illuminates occurrences of a word
  {
    "RRethy/vim-illuminate"
  },

  -- highlight, list and search todo comments in your projects
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
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
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)"
      },
      { "<leader>bw", buf_wipeout, desc = "Wipeout hidden buffers" },
    },
  },

  -- navigate between vim and tmux panes easily
  {
    "christoomey/vim-tmux-navigator",
    enabled = vim.fn.executable("tmux") == 1,
    keys = {
      { "<M-h>", ":TmuxNavigateLeft<cr>",     silent = true },
      { "<M-j>", ":TmuxNavigateDown<cr>",     silent = true },
      { "<M-k>", ":TmuxNavigateUp<cr>",       silent = true },
      { "<M-l>", ":TmuxNavigateRight<cr>",    silent = true },
      { "<M-;>", ":TmuxNavigatePrevious<cr>", silent = true },
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

  {
    "rmagatti/auto-session",
    opts = {
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "/" },
      auto_session_use_git_branch = true,
      pre_save_cmds = {
        function()
          local current_tab = vim.fn.tabpagenr()
          pcall(vim.cmd.tabdo, "Neotree close")
          pcall(vim.cmd.tabdo, "TroubleClose")
          pcall(vim.cmd.tabdo, "UndotreeHide")
          vim.cmd.tabnext(current_tab)
        end,
      },
    },
  },
}
