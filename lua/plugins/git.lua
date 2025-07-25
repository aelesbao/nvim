-- Plugins to interact with git

return {
  "tpope/vim-fugitive",

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = true,
      trouble = true,
      _on_attach_pre = function(_, callback)
        callback()
      end,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { desc = "Next change", expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { desc = "Previous change", expr = true })

        -- Actions
        map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
        map(
          "v",
          "<leader>ghs",
          function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          { desc = "Stage hunk" }
        )
        map(
          "v",
          "<leader>ghr",
          function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          { desc = "Reset hunk" }
        )
        map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
        map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff with base" })
        map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },

  -- A fully featured GitHub integration for performing code reviews in Neovim.
  {
    "ldelossa/gh.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
      },
    },
    opts = {},
    keys = {
      { "<leader>gP", ":GHOpenPR<cr>",    desc = "Open a GitHub Pull Request" },
      { "<leader>gI", ":GHOpenIssue<cr>", desc = "Open a GitHub Issue" },
      { "<leader>gS", ":GHSearchPRs<cr>", desc = "Search Pull Requests on GitHub" },
    },
    config = function(_, opts)
      require("litee.gh").setup(opts)
    end,
  },

}
