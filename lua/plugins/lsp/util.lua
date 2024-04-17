local M = {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local format_timeout_ms = 3000
local format_group_name = "lsp_autoformat"
local format_group = augroup(format_group_name, { clear = false })

function M.buf_kset(bufnr, mode, lhs, rhs, desc)
  if mode == nil then
    return function(...) M.buf_kset(bufnr, ...) end
  end

  local opts = { buffer = bufnr, desc = desc, remap = true, silent = true, }
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.setup_mappings(bufnr)
  local kset = M.buf_kset(bufnr)

  local lsp = vim.lsp.buf
  local diagnostic = vim.diagnostic
  local telescope = require("telescope.builtin")
  local trouble = require("trouble")

  kset("n", "K", lsp.hover, "Hover")
  kset("n", "gK", lsp.signature_help, "Signature help")
  kset({ "n", "i", "x" }, "<C-k>", lsp.signature_help, "Signature help")

  -- kset("n", "gd", function() trouble.open({ mode = "lsp_definitions" }) end, "Definition")
  kset("n", "gd", function() telescope.lsp_definitions({ reuse_win = true, jump_type = "vsplit" }) end, "Definition")
  kset("n", "gD", function() lsp.declaration({ reuse_win = true }) end, "Declaration")
  kset("n", "gR", function() telescope.lsp_references({ jump_type = "vsplit" }) end, "References")
  kset("n", "gr", function() trouble.open({ mode = "lsp_references", focus = true }) end, "References")
  -- kset("n", "gR", function() lsp.references() end, "References")
  kset("n", "gI", function() lsp.implementation({ reuse_win = true, jump_type = "vsplit" }) end, "Implementation")
  kset("n", "gy", function() lsp.type_definition({ reuse_win = true }) end, "Type definition")
  kset("n", "gi", function()
    telescope.lsp_implementations({ jump_type = "vsplit", reuse_win = true })
  end, "Implementation")

  kset({ "n" }, "<leader>ca", lsp.code_action, "Code action")
  kset({ "n", "i" }, "<M-CR>", lsp.code_action, "Code action")

  if vim.lsp.buf.range_code_action then
    kset("x", "<M-CR>", lsp.range_code_action)
  else
    kset("x", "<M-CR>", lsp.code_action)
  end

  if vim.lsp.inlay_hint then
    kset("n", "<leader>ch", function()
      local enabled = vim.lsp.inlay_hint.is_enabled()
      vim.lsp.inlay_hint.enable(bufnr, not enabled)
    end, "Inlay hints")
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

  kset("n", "xd", diagnostic.open_float, "Diagnostic in a floating window")
  kset("n", "[d", diagnostic.goto_prev, "Previous diagnostic")
  kset("n", "]d", diagnostic.goto_next, "Next diagnostic")

  kset("n", "<leader>ss", telescope.lsp_workspace_symbols, "Search workspace symbols")

  kset("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add folder to workspace")
  kset("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove folder from workspace")
  kset("n", "<leader>wl", function()
    vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
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

  M.buf_kset(bufnr, "n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
  M.buf_kset(bufnr, "n", "<leader>cL", vim.lsp.codelens.refresh, "Refresh code lens")
end

return M
