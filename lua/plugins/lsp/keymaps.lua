local utils = require("utils")
local format = require("plugins.lsp.format")

local default_floating_opts = { border = "rounded", focusable = true, focus = true }
local default_location_opts = { reuse_win = true, jump_type = "vsplit" }

local M = {}

function M.setup_global_keymaps()
  local k = vim.keymap
  local lsp = vim.lsp.buf

  -- lsp
  k.set("n", "gri", function() lsp.implementation(default_location_opts) end, { desc = "Implementation" })
  k.set("n", "grt", function() lsp.type_definition(default_location_opts) end, { desc = "Type definition" })
  k.set("n", "grD", function() lsp.declaration({ reuse_win = true }) end, { desc = "Declaration" })
  k.set("n", "grd", function() lsp.definition(default_location_opts) end, { desc = "Definition" })
  k.set("n", "grr", lsp.references, { desc = "References" })
  k.set("n", "grc", lsp.incoming_calls, { desc = "Incoming Calls" })
  k.set("n", "grC", lsp.outgoing_calls, { desc = "Outgoing Calls" })
  k.set("n", "grn", lsp.rename, { desc = "Rename" })
  k.set("n", "gO", lsp.document_symbol, { desc = "Document Symbols" })

  -- shortcuts
  k.set("n", "<F18>", "grn", { desc = "Rename" })
  k.set("i", "<F18>", "<C-o><S-F6>", { desc = "Rename" })

  -- workspaces
  k.set("n", "<leader>wa", function()
    vim.ui.input(
      {
        prompt = "Add Workspace Folder: ",
        default = vim.fn.getcwd(),
        completion = "dir",
      },
      function(path)
        if path and #path > 0 then
          lsp.add_workspace_folder(path)
        end
      end
    )
  end, { desc = "Add folder to workspace" })
  k.set("n", "<leader>wr", function()
    vim.ui.select(
      lsp.list_workspace_folders(),
      { prompt = "Remove Workspace Folder", kind = "dir" },
      function(path)
        if path and #path > 0 then
          lsp.remove_workspace_folder(path)
        end
      end
    )
  end, { desc = "Remove folder from workspace" })
  k.set("n", "<leader>wl", function()
    vim.ui.select(
      lsp.list_workspace_folders(),
      { prompt = "Workspace Folders", kind = "dir" },
      function() end
    )
  end, { desc = "List workspace folders" })
end

function M.setup_buf_keymaps(client, bufnr)
  local kset = utils.buf_kset(bufnr)
  local lsp = vim.lsp.buf

  kset("n", "K", function() lsp.hover(default_floating_opts) end, "Hover")
  kset("n", "gK", function() lsp.signature_help(default_floating_opts) end, "Signature help")
  kset({ "n", "i", "x" }, "<C-k>", function() lsp.signature_help(default_floating_opts) end, "Signature help")

  if client.server_capabilities.codeAction then
    kset({ "n" }, "gra", lsp.code_action, "Code action")
    kset({ "n" }, "<leader>ca", "gra", "Code action")
    kset({ "n", "i" }, "<M-CR>", lsp.code_action, "Code action")

    if vim.lsp.buf.range_code_action then
      kset("x", "<M-CR>", lsp.range_code_action)
    else
      kset("x", "<M-CR>", lsp.code_action)
    end
  end

  kset({ "n", "x" }, "<leader>cf", function() format.format(bufnr) end, "Format code")
  kset({ "n", "x" }, "<C-M-l>", "<leader>cf", "Format code")

  local diagnostic = vim.diagnostic
  kset("n", "xd", diagnostic.open_float, "Diagnostic in a floating window")
  kset("n", "[d", function() diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
  kset("n", "]d", function() diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")

  if client.server_capabilities.codeLensProvider then
    kset("n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
    kset("n", "<leader>cL", vim.lsp.codelens.refresh, "Refresh code lens")
  end
end

return M
