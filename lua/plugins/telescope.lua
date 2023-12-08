-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function telescope_live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end


return {
  -- Fuzzy finder for anything
  {
    "nvim-telescope/telescope.nvim",
    version = false, -- telescope did only one release, so use HEAD for now
    cmd = "Telescope",
    keys = {
      -- find
      { "<C-p>",      "<cmd>Telescope find_files<cr>",                desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>",                  desc = "Find in recent files" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current buffer" },
      { "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "Find all" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",          desc = "Find buffers" },

      -- search
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
      { "<leader>sG", telescope_live_grep_git_root,     desc = "Live grep on git root" },
      { "<leader>s/", telescope_live_grep_open_files,   desc = "Live grep on open files" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",       desc = "Jump to mark" },
      { "<leader>sn", "<cmd>Telescope notify<cr>",      desc = "Notifications" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",     desc = "Keymaps" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },

      -- git
      { "<leader>gf", "<cmd>Telescope git_files<cr>",   desc = "Git files" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",  desc = "Git status" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
      "folke/trouble.nvim",
    },
    opts = {
      defaults = {
        color_devicons = true,
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
        set_env = { ["COLORTERM"] = "truecolor", },
      },
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- "smart_case" or "ignore_case" or "respect_case"
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local trouble = require("trouble.providers.telescope")

      local trouble_mapping = { ["<c-t>"] = trouble.open_with_trouble }
      -- opts.defaults.mappings.i:append(trouble_mapping)
      -- opts.defaults.mappings.n:append(trouble_mapping)

      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
