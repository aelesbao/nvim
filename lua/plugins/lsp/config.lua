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
    filetypes = { "html", "twig", "hbs" },
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
  },
}

local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

local navic = require("nvim-navic")

lsp_zero.on_attach(function(client, bufnr)
  local function kset(mode, lhs, rhs, desc)
    local opts = { buffer = bufnr, remap = false, desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local lsp = vim.lsp.buf
  local diagnostic = vim.diagnostic
  local telescope = require("telescope.builtin")

  kset("n", "K", lsp.hover, "Hover")
  kset("n", "gK", lsp.signature_help, "Signature help")
  kset({ "n", "i", "x" }, "<C-k>", lsp.signature_help, "Signature help")

  kset("n", "gD", function() lsp.declaration({ reuse_win = true }) end, "Goto Declaration")
  kset("n", "gd", function() lsp.definition({ reuse_win = true }) end, "Goto Definition")
  kset("n", "gr", function() lsp.references({ reuse_win = true }) end, "References")
  kset("n", "gI", function() lsp.implementation({ reuse_win = true }) end, "Implementation")
  kset("n", "gy", function() lsp.type_definition({ reuse_win = true }) end, "Goto Type definition")

  kset("n", "<leader>sd", function() telescope.lsp_definitions({ reuse_win = true }) end, "Goto Definition")
  kset("n", "<leader>sr", telescope.lsp_references, "References")
  kset("n", "<leader>sI", function() telescope.lsp_implementations({ reuse_win = true }) end, "Goto Implementation")
  kset("n", "<leader>sy", function() telescope.lsp_type_definitions({ reuse_win = true }) end, "Goto Type Definition")

  kset({ "n", "v" }, "<leader>ca", lsp.code_action, "Code action")
  kset({ "n", "i" }, "<C-CR>", lsp.code_action, "Code action")
  kset("n", "<leader>cr", lsp.rename, "Rename")
  kset("n", "<S-F6>", lsp.rename, "Rename")
  kset({ "n", "x" }, "<leader>cf", function() lsp.format({ async = false }) end, "Format code")

  kset("n", "gl", diagnostic.open_float, "Show diagnostic in a floating window")
  kset("n", "[d", diagnostic.goto_next, "Next diagnostic")
  kset("n", "]d", diagnostic.goto_prev, "Previous diagnostic")

  if client.server_capabilities.documentFormattingProvider then
    lsp_zero.buffer_autoformat({}, bufnr, { async = false, timeout_ms = 3000 })
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end)

-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    lsp_zero.default_setup,
  },
})

-- dinamically install servers with lsp-zero
local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = lsp_zero.on_attach,
    capabilities = lsp_zero.capabilities,
  }, config))
end
