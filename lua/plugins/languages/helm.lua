return {
  -- vim syntax for helm templates
  {
    "towolf/vim-helm",
    ft = "helm",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      require("lspconfig").helm_ls.setup({
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "yaml-language-server",
            }
          }
        },
        capabilities = capabilities,
      })
    end,
  },
}
