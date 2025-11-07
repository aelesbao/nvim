local navic = require("nvim-navic")
local keymaps = require("plugins.lsp.keymaps")
local format = require("plugins.lsp.format")
local autocmd = require("plugins.lsp.autocmd")

vim.lsp.config("*", {
  on_error = function(code, err)
    vim.notify("[" .. code .. "]" .. err, vim.log.levels.ERROR, { title = "LSP Server Error" })
  end,
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "yamlls",
    "jsonls",
    "bashls", -- bash/sh
    "taplo",  -- toml
  },
})

keymaps.setup_global_keymaps()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf
    local client = assert(
      vim.lsp.get_client_by_id(event.data.client_id),
      "Failed to get LSP client #" .. event.data.client_id .. " in buffer #" .. bufnr
    )

    keymaps.setup_buf_keymaps(client, bufnr)
    format.buffer_format(client, bufnr)
    autocmd.setup(client, bufnr)

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end,
})

vim.diagnostic.config({
  -- Enable virtual text diagnostics for the current cursor line
  virtual_text = { current_line = false, source = "if_many", virt_text_pos = "eol" },

  -- Only show virtual line diagnostics for the current cursor line
  virtual_lines = false,

  -- Change the text content of the diagnostic signs
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- enable for troubleshooting
-- vim.lsp.set_log_level("debug")
