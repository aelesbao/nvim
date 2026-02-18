local navic = require("nvim-navic")
local keymaps = require("plugins.lsp.keymaps")
local format = require("plugins.lsp.format")
local autocmd = require("plugins.lsp.autocmd")

local function lsp_err_to_string(err)
  if err == nil then
    return "<nil>"
  end

  if type(err) == "string" then
    return err
  end

  if type(err) ~= "table" then
    return tostring(err)
  end

  -- Common JSON-RPC error shape:
  -- { error = { code = <num>, message = <string>, data = <any> }, id = <any>, jsonrpc = "2.0" }
  local e = err.error
  if type(e) == "table" then
    local parts = {}

    local msg = e.message
    if type(msg) == "string" and msg ~= "" then
      parts[#parts + 1] = msg
    end

    if e.code ~= nil then
      parts[#parts + 1] = ("rpc_code=%s"):format(tostring(e.code))
    end

    if e.data ~= nil then
      if type(e.data) == "string" then
        parts[#parts + 1] = ("data=%s"):format(e.data)
      else
        parts[#parts + 1] = ("data=%s"):format(vim.inspect(e.data))
      end
    end

    if err.id ~= nil then
      parts[#parts + 1] = ("id=%s"):format(tostring(err.id))
    end

    if #parts > 0 then
      return table.concat(parts, " | ")
    end
  end

  -- Fallback: full table dump
  return vim.inspect(err)
end

vim.lsp.config("*", {
  on_error = function(code, err)
    local msg = lsp_err_to_string(err)
    vim.notify(("[%s] %s"):format(tostring(code), msg), vim.log.levels.ERROR, { title = "LSP Server Error" })
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

  float = {
    show_header = true,
    source = true,
    border = 'rounded',
    focusable = true,
  },
})

-- enable for troubleshooting
-- vim.lsp.set_log_level("debug")
