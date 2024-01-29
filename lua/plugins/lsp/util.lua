local M = {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local format_timeout_ms = 3000
local format_group_name = "lsp_autoformat"
local format_group = augroup(format_group_name, { clear = false })

function M.buf_kset(bufnr, mode, lhs, rhs, desc)
  local opts = { buffer = bufnr, remap = true, desc = desc }
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.setup_mappings(bufnr)
  local function kset(...) M.buf_kset(bufnr, ...) end

  local lsp = vim.lsp.buf
  local diagnostic = vim.diagnostic

  kset("n", "K", lsp.hover, "Hover")
  kset("n", "gK", lsp.signature_help, "Signature help")
  kset({ "n", "i", "x" }, "<C-k>", lsp.signature_help, "Signature help")

  kset("n", "gD", function() lsp.declaration({ reuse_win = true }) end, "Declaration")
  kset("n", "gd", function() lsp.definition({ reuse_win = true }) end, "Definition")
  kset("n", "gr", function() lsp.references() end, "References")
  kset("n", "gI", function() lsp.implementation({ reuse_win = true }) end, "Implementation")
  kset("n", "gy", function() lsp.type_definition({ reuse_win = true }) end, "Type definition")

  kset({ "n" }, "<leader>ca", lsp.code_action, "Code action")
  kset({ "n", "i" }, "<M-CR>", lsp.code_action, "Code action")

  if vim.lsp.buf.range_code_action then
    kset("x", "<M-CR>", vim.lsp.buf.range_code_action)
  else
    kset("x", "<M-CR>", vim.lsp.buf.code_action)
  end

  kset("n", "<leader>cr", lsp.rename, "Rename")
  kset("n", "<F18>", lsp.rename, "Rename")
  kset("i", "<F18>", "<C-o><S-F6>", "Rename")

  kset(
    { "n", "x" },
    "<leader>cf",
    function() lsp.format({ async = false, timeout_ms = format_timeout_ms }) end,
    "Format code"
  )
  kset(
    { "n", "x" },
    "<C-M-l>",
    function() lsp.format({ async = false, timeout_ms = format_timeout_ms }) end,
    "Format code"
  )

  kset("n", "gl", diagnostic.open_float, "Show diagnostic in a floating window")
  kset("n", "[d", diagnostic.goto_prev, "Previous diagnostic")
  kset("n", "]d", diagnostic.goto_next, "Next diagnostic")
end

local function is_autoformat_enabled()
  local autoformat = vim.b.enable_autoformat
  if autoformat == nil then
    ---@diagnostic disable-next-line: inject-field
    vim.b.enable_autoformat = true
  end

  return (autoformat == 1 or autoformat == true)
end

function M.buffer_autoformat(client, bufnr, opts)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  opts = opts or {}

  if not client.server_capabilities.documentFormattingProvider then return end

  vim.api.nvim_clear_autocmds({ group = format_group_name, buffer = bufnr })

  autocmd("BufWritePre", {
    group = format_group,
    desc = "Format current buffer",
    buffer = bufnr,
    callback = function()
      if is_autoformat_enabled() then
        vim.lsp.buf.format({
          async = false,
          bufnr = bufnr,
          timeout_ms = opts.timeout_ms or format_timeout_ms,
          formatting_options = opts.formatting_options,
        })
      end
    end
  })
end

function M.setup_code_lens(client, bufnr)
  if not client.server_capabilities.codeLensProvider then
    return
  end

  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    group = augroup("lsp_codelens", { clear = true }),
    desc = "Automatically refresh code lens",
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh()
    end,
  })

  M.buf_kset(bufnr, "n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
end

return M
