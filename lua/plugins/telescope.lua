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
