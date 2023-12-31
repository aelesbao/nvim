return {
  {
    "simrat39/rust-tools.nvim",
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<leader>ch", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Hover actions" })
            -- Code action groups
            vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr, desc = "Code actions" })

            vim.keymap.set('n', '<Leader>cb', ':! cargo build<CR>')
            vim.keymap.set('n', '<Leader>ct', ':! cargo test<CR>')
          end,
        },
      })
    end,
  },

  {
    "saecki/crates.nvim",
    tag = "stable",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = {
      null_ls = {
        enabled = true,
      },
    },
  },
}
