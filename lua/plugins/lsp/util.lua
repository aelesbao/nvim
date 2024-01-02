local M = {}

local timeout_ms = 10000

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

function M.buf_kset(bufnr, mode, lhs, rhs, desc)
  local opts = { buffer = bufnr, remap = true, desc = desc }
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.setup_mappings(bufnr)
  local function kset(...) M.buf_kset(bufnr, ...) end

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
  kset({ "n", "x" }, "<leader>cf", function() lsp.format({ async = false, timeout_ms = 3000 }) end, "Format code")

  kset("n", "gl", diagnostic.open_float, "Show diagnostic in a floating window")
  kset("n", "[d", diagnostic.goto_next, "Next diagnostic")
  kset("n", "]d", diagnostic.goto_prev, "Previous diagnostic")
end

function M.buffer_autoformat(client, bufnr, opts)
  client = client or {}
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  opts = opts or {}

  if vim.b.enable_autoformat == nil then
    ---@diagnostic disable-next-line: inject-field
    vim.b.enable_autoformat = 1
  end

  local group = "lsp_autoformat"
  local desc = "Format current buffer"

  if client.name then
    group = string.format("buffer_autoformat_%s", client.name)
    desc = string.format("Format buffer with %s", client.name)
  end

  local format_group = augroup(group, { clear = false })
  vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

  if client.server_capabilities and not client.server_capabilities.documentFormattingProvider then
    return
  end

  autocmd("BufWritePre", {
    group = format_group,
    desc = desc,
    buffer = bufnr,
    callback = function()
      local autoformat = vim.b.enable_autoformat
      local enabled = (autoformat == 1 or autoformat == true)
      if not enabled then
        return
      end

      local config = {
        async = false,
        id = client.id,
        name = client.name,
        bufnr = bufnr,
        timeout_ms = opts.timeout_ms or timeout_ms,
        formatting_options = opts.formatting_options,
      }

      vim.lsp.buf.format(config)
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
