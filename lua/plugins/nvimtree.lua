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
}
