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

  -- read or write files with sudo command
  { "lambdalisue/vim-suda", tag = "v1.2.4", },

  -- easily interact with tmux from vim
  {
    "preservim/vimux",
    lazy = false,
    keys = {
      { "<leader>vl", ":VimuxRunLastCommand<cr>",      desc = "Run last vimux command" },
      { "<leader>vi", ":VimuxInspectRunner<cr>",       desc = "Move into the runner in copy mode" },
      { "<C-M-u>",    ":VimuxScrollUpInspect<cr>",     desc = "Scrolls the runner up" },
      { "<C-M-d>",    ":VimuxScrollDownInspect<cr>",   desc = "Scrolls the runner down" },
      { "<leader>vk", ":VimuxClearTerminalScreen<cr>", desc = "Clears the runner terminal screen" },
      { "<leader>vo", ":VimuxOpenRunner<cr>",          desc = "Opens the vimux runner" },
      { "<leader>vq", ":VimuxCloseRunner<cr>",         desc = "Close the vimux runner" },
    },
    init = function()
      -- the part of the screen the split pane Vimux will spawn should take up
      vim.g.VimuxHeight = "30%"
      -- default orientation of the split tmux pane
      vim.g.VimuxOrientation = "h"
      -- addtional arguments to be passed to the tmux command that opens the runner
      vim.g.VimuxOpenExtraArgs = [[ -c \#\{pane_current_path\} ]]
    end,
  },

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
      { "<M-h>", ":TmuxNavigateLeft<cr>",                 mode = { "n" }, silent = true },
      { "<M-j>", ":TmuxNavigateDown<cr>",                 mode = { "n" }, silent = true },
      { "<M-k>", ":TmuxNavigateUp<cr>",                   mode = { "n" }, silent = true },
      { "<M-l>", ":TmuxNavigateRight<cr>",                mode = { "n" }, silent = true },
      { "<M-;>", ":TmuxNavigatePrevious<cr>",             mode = { "n" }, silent = true },
      { "<M-h>", "<C-o>:TmuxNavigateLeft<cr>",            mode = { "i" }, silent = true },
      { "<M-j>", "<C-o>:TmuxNavigateDown<cr>",            mode = { "i" }, silent = true },
      { "<M-k>", "<C-o>:TmuxNavigateUp<cr>",              mode = { "i" }, silent = true },
      { "<M-l>", "<C-o>:TmuxNavigateRight<cr>",           mode = { "i" }, silent = true },
      { "<M-;>", "<C-o>:TmuxNavigatePrevious<cr>",        mode = { "i" }, silent = true },
      { "<M-h>", [[<C-\><C-o>:TmuxNavigateLeft<cr>]],     mode = { "t" }, silent = true },
      { "<M-j>", [[<C-\><C-o>:TmuxNavigateDown<cr>]],     mode = { "t" }, silent = true },
      { "<M-k>", [[<C-\><C-o>:TmuxNavigateUp<cr>]],       mode = { "t" }, silent = true },
      { "<M-l>", [[<C-\><C-o>:TmuxNavigateRight<cr>]],    mode = { "t" }, silent = true },
      { "<M-;>", [[<C-\><C-o>:TmuxNavigatePrevious<cr>]], mode = { "t" }, silent = true },
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

  -- improve viewing Markdown files
  {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- provides completions for both checkboxes and callouts
      completions = { lsp = { enabled = true } },
      file_types = { "markdown", "Avante", "codecompanion" },
      preset = "obsidian",
    },
    ft = { "markdown", "Avante", "codecompanion" },
  },
}
