return {
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    event = "User DirOpened",
    keys = {
      { "<F9>",   vim.cmd.NvimTreeToggle,   desc = "NvimTree" },
      { "<S-F9>", vim.cmd.NvimTreeFindFile, desc = "NvimTree Find File" },
    },
    opts = {
      disable_netrw = true,
      hijack_cursor = true,
      hijack_netrw = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      filesystem_watchers = {
        enable = true,
      },
      filters = {
        dotfiles = true,
        git_ignored = false,
      },
      git = {
        enable = true,
      },
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      notify = {
        threshold = vim.log.levels.INFO,
      },
      renderer = {
        highlight_opened_files = "all",
        group_empty = true,
        root_folder_label = false,
        special_files = {
          "Cargo.toml",
          "Makefile",
          "package.json",
          "README.md",
          "readme.md",
        },
        icons = {
          git_placement = "after",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            git = {
              unstaged = "",
              staged = "",
              unmerged = "",
              renamed = "",
              untracked = "?",
              deleted = "",
              ignored = "",
            },
          },
        },
      },
      sort = {
        sorter = "case_sensitive",
      },
      system_open = {
        cmd = nil,
        args = {},
      },
      tab = {
        sync = {
          open = true,
          close = true,
          ignore = {},
        },
      },
      ui = {
        confirm = {
          trash = false,
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
      view = {
        adaptive_size = false,
        preserve_window_proportions = true,
        side = "left",
        signcolumn = "yes",
        width = 30,
      },
    },
    config = function(_, opts)
      -- disable netrw when nvim-tree loads
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Test: closes nvim-tree when it's the last buffer
      -- vim.autocmd BufEnter * ++nested if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif

      require("nvim-tree").setup(opts)
    end,
  },

  -- beautitul icons
  {
    "nvim-tree/nvim-web-devicons",
  },

  -- Fuzzy finder.
  -- The default key bindings to find files will use Telescope's
  -- `find_files` or `git_files` depending on whether the
  -- directory is a git repo.
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
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",                 desc = "Live grep" },
      { "<leader>ss", function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end,                                                            desc = "Grep" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",                     desc = "Jump to mark" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                 desc = "Help tags" },

      -- git
      { "<leader>gf", "<cmd>Telescope git_files<cr>",   desc = "Git files" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",  desc = "Git status" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
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
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
