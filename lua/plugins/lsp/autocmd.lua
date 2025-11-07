local utils = require("utils")

local highlight_group = utils.augroup("lsp_highlight_symbol")
local codelens_group = utils.augroup("lsp_codelens")

local M = {}

function M.setup(client, bufnr)
  if client:supports_method("textDocument/documentHighlight") then
    vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = bufnr })

    utils.create_autocmd({ "CursorHold", "CursorHoldI" }, {
      desc = "Highlight document symbols in current buffer",
      group = highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    utils.create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      desc = "Highlight document symbols in current buffer",
      group = highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_clear_autocmds({ group = codelens_group, buffer = bufnr })

    utils.create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      desc = "Refresh codelens in current buffer",
      group = codelens_group,
      buffer = bufnr,
      callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end
    })
  end
end

return M
