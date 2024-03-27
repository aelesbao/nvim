return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>et", ":Neotest summary toggle<cr>",      desc = "Test summary", },
      { "<leader>ts", ":Neotest summary toggle<cr>",      desc = "Open test summary", },
      { "<leader>to", ":Neotest output open<cr>",         desc = "Open test output", },
      { "<leader>tO", ":Neotest output-panel toggle<cr>", desc = "Open output panel", },
      { "<leader>tc", ":Neotest output-panel clear<cr>",  desc = "Clear output panel", },
      { "<leader>tt", ":Neotest run<cr>",                 desc = "Run nearest test", },
      { "<leader>tf", ":Neotest run file<cr>",            desc = "Run tests in current file", },
      { "<leader>tl", ":Neotest run last<cr>",            desc = "Run last test", },
    },
    --- @type neotest.Config
    opts = {
      output = {
        enabled = true,
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
      },
      summary = {
        enabled = true,
        animated = true,
        follow = true,
      },
      status = {
        enabled = true,
        signs = true,
      }
    },
  }
}
