local lsp_util = require("plugins.lsp.util")

return {
  {
    "simrat39/rust-tools.nvim",
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local rt = require("rust-tools")
      rt.setup({
        server = {
          server = {
            settings = {
              capabilities = capabilities,
              standalone = true,

              ["rust-analyzer"] = {
                assist = {
                  importEnforceGranularity = true,
                  importPrefix = "crate",
                },
                cargo = {
                  allFeatures = true,
                },
                checkOnSave = {
                  command = "clippy",
                },
                -- inlayhints = {
                --   bindingModeHints = {
                --     enable = true,
                --   },
                --   chainingHints = {
                --     enable = true,
                --   },
                --   closingBraceHints = {
                --     enable = true,
                --   },
                --   lifetimeElisionHints = {
                --     enable = 'never',
                --   },
                --   useParameterNames = true,
                --   parameterHints = {
                --     enable = true,
                --   },
                --   typeHints = {
                --     enable = true,
                --   },
                -- },
              },
            },
          },
          on_attach = function(_, bufnr)
            lsp_util.buf_kset(bufnr, "n", "<leader>ch", rt.hover_actions.hover_actions, "Hover actions")
            lsp_util.buf_kset(bufnr, "n", "<leader>ca", rt.code_action_group.code_action_group, "Code actions")

            lsp_util.buf_kset(bufnr, "n", "<leader>cb", ":! cargo build<cr>", "Build")
            lsp_util.buf_kset(bufnr, "n", "<leader>ct", ":! cargo nextest run<cr>", "Run tests")
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
