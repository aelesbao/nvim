local utils = require("utils")
local lsp_format = require("lsp-format")

local format_group_name = "lsp_autoformat"
local format_group = utils.augroup(format_group_name)

local function is_autoformat_enabled()
  local autoformat = vim.b.autoformat
  if autoformat == nil then
    ---@diagnostic disable-next-line: inject-field
    vim.b.autoformat = true
  end

  return (autoformat == 1 or autoformat == true)
end

local M = {}

function M.format(bufnr)
  lsp_format.format({ buf = bufnr, async = false, timeout_ms = 3000 })
end

function M.buffer_format(client, bufnr, opts)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  opts = opts or {}

  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  lsp_format.on_attach(client, bufnr)

  vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
  utils.create_autocmd("BufWritePre", {
    group = format_group,
    desc = "Format current buffer",
    buffer = bufnr,
    callback = function()
      if is_autoformat_enabled() then
        M.format(bufnr)
      end
    end
  })
end

return M
