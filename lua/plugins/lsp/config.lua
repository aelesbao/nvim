-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property "filetypes" to the map in question.
local servers = {
  bashls = {}, -- bash/sh
  taplo = {},  -- toml

  html = {
    filetypes = { "html", "twig", "hbs"}
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
      diagnostics = { disable = { "missing-fields" } },
    },
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
  }
}

local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

local navic = require("nvim-navic")

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end)

lsp_zero.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 5000,
  },
  -- servers = {
  --   ["tsserver"] = {"javascript", "typescript"},
  --   ["rust_analyzer"] = {"rust"},
  -- },
})

-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    lsp_zero.default_setup,
  }
})

-- dinamically install servers with lsp-zero
local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = lsp_zero.on_attach,
    capabilities = lsp_zero.capabilities,
  }, config))
end
