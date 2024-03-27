local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

local lsp_util = require("plugins.lsp.util")
local navic = require("nvim-navic")

lsp_zero.on_attach(function(client, bufnr)
  lsp_util.setup_mappings(bufnr)
  lsp_util.setup_code_lens(client, bufnr)
  lsp_util.buffer_autoformat(client, bufnr)

  -- if client.server_capabilities.documentFormattingProvider then
  --   lsp_zero.buffer_autoformat({}, bufnr, { timeout_ms = 3000 })
  -- end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end)

lsp_zero.set_sign_icons({
  hint = "󰌵",
  info = "",
  warn = "",
  error = "",
})

-- Enable the following language servers
--
-- Add any additional override configuration in the following tables. They will be passed to
-- the `settings` field of the server config. You must look up that documentation yourself.
--
-- If you want to override the default filetypes that your language server will attach to you can
-- define the property "filetypes" to the map in question.
local servers = {
  bashls = {}, -- bash/sh
  taplo = {
    on_attach = function(client, bufnr)
      lsp_zero.on_attach(client, bufnr)

      lsp_util.buf_kset(bufnr, "n", "K", function()
        if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
          require("crates").show_popup()
        else
          vim.lsp.buf.hover()
        end
      end, "Show Crate documentation")
    end
  },  -- toml

  html = {
    filetypes = { "html", "twig", "hbs" },
  },

  -- yaml
  yamlls = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },

  -- json
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    lsp_zero.default_setup,
  },
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- dinamically install servers with lsp-zero
local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = lsp_zero.on_attach,
    capabilities = capabilities,
  }, config))
end
