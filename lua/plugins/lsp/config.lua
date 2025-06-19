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

local utils = require("utils")
local lsp_format = require("lsp-format")
local telescope = require("telescope.builtin")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local format_timeout_ms = 3000
local format_group_name = "lsp_autoformat"
local format_group = augroup(format_group_name, { clear = false })

local function format(bufnr)
  lsp_format.format({ buf = bufnr, async = false, timeout_ms = format_timeout_ms })
end

local function setup_keymaps(bufnr)
  local kset = utils.buf_kset(bufnr)

  local lsp = vim.lsp.buf
  local diagnostic = vim.diagnostic

  kset("n", "K", function()
    lsp.hover({ border = "rounded", focusable = true, focus = true, })
  end, "Hover")

  kset("n", "gK", function()
    lsp.signature_help({ border = "rounded", focusable = true, focus = true, })
  end, "Signature help")
  kset({ "n", "i", "x" }, "<C-k>", function()
    lsp.signature_help({ border = "rounded", focusable = true, focus = true, })
  end, "Signature help")

  -- kset("n", "gd", function() trouble.open({ mode = "lsp_definitions" }) end, "Definition")
  kset("n", "gd", function() telescope.lsp_definitions({ reuse_win = true, jump_type = "vsplit" }) end, "Definition")
  kset("n", "gD", function() lsp.declaration({ reuse_win = true }) end, "Declaration")
  kset("n", "gR", function() telescope.lsp_references({ reuse_win = true, jump_type = "vsplit" }) end, "References")
  -- kset("n", "gR", function() lsp.references() end, "References")
  kset("n", "gy", function() lsp.type_definition({ reuse_win = true }) end, "Type definition")
  kset("n", "gI", function() lsp.implementation({ reuse_win = true, jump_type = "vsplit" }) end, "Implementation")
  kset("n", "gi", function()
    telescope.lsp_implementations({ reuse_win = true, jump_type = "vsplit" })
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
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr })
    end, "Inlay hints toggle")
  end

  kset("n", "<leader>cr", lsp.rename, "Rename")
  kset("n", "<F18>", lsp.rename, "Rename")
  kset("i", "<F18>", "<C-o><S-F6>", "Rename")

  kset({ "n", "x" }, "<leader>cf", function() format(bufnr) end, "Format code")
  kset({ "n", "x" }, "<C-M-l>", function() format(bufnr) end, "Format code")
  -- kset({ "n", "x" }, "<C-M-l>", ":Format<Enter>", "Format code")

  kset("n", "xd", diagnostic.open_float, "Diagnostic in a floating window")
  kset("n", "[d", function() diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
  kset("n", "]d", function() diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")

  kset("n", "<leader>ss", telescope.lsp_workspace_symbols, "Search workspace symbols")

  kset("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add folder to workspace")
  kset("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove folder from workspace")
  kset("n", "<leader>wl", function()
    vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
end

local function is_autoformat_enabled()
  local autoformat = vim.b.autoformat
  if autoformat == nil then
    ---@diagnostic disable-next-line: inject-field
    vim.b.autoformat = true
  end

  return (autoformat == 1 or autoformat == true)
end

local function buffer_format(client, bufnr, opts)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  opts = opts or {}

  if not client.server_capabilities.documentFormattingProvider then
    return
  end

  lsp_format.on_attach(client, bufnr)

  vim.api.nvim_clear_autocmds({ group = format_group_name, buffer = bufnr })
  autocmd("BufWritePre", {
    group = format_group,
    desc = "Format current buffer",
    buffer = bufnr,
    callback = function()
      if is_autoformat_enabled() then
        format(bufnr)
        -- vim.lsp.buf.format({
        --   async = false,
        --   bufnr = bufnr,
        --   timeout_ms = opts.timeout_ms or format_timeout_ms,
        --   formatting_options = opts.formatting_options,
        -- })
      end
    end
  })
end

local function setup_code_lens(client, bufnr)
  if not client.server_capabilities.codeLensProvider then
    return
  end

  utils.buf_kset(bufnr, "n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
  utils.buf_kset(bufnr, "n", "<leader>cL", vim.lsp.codelens.refresh, "Refresh code lens")
end

local navic = require("nvim-navic")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local bufnr = event.buf

    setup_keymaps(bufnr)
    setup_code_lens(client, bufnr)
    buffer_format(client, bufnr)

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end,
})

vim.diagnostic.config({
  -- Enable virtual text diagnostics for the current cursor line
  virtual_text = { current_line = true },

  -- Only show virtual line diagnostics for the current cursor line
  virtual_lines = { current_line = true, },

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
