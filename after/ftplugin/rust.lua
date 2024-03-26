if vim.g.did_rustaceanvim_initialize then
  local lsp_util = require("plugins.lsp.util")
  local bufnr = vim.api.nvim_get_current_buf()

  lsp_util.buf_kset(bufnr, "n", "<C-space>", function()
    vim.cmd.RustLsp { "hover", "actions" }
  end, "Hover actions")

  lsp_util.buf_kset(bufnr, "n", "<leader>ch", function()
    vim.cmd.RustLsp { "hover", "actions" }
  end, "Hover actions")

  lsp_util.buf_kset(bufnr, "n", "<leader>ca", function()
    vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end, "Code actions")

  lsp_util.buf_kset(bufnr, "n", "<leader>ce", function()
    vim.cmd.RustLsp("explainError")
  end, "Explain error")

  lsp_util.buf_kset(bufnr, "n", "<leader>cx", function()
    vim.cmd.RustLsp("renderDiagnostic")
  end, "Render diagnostic")

  lsp_util.buf_kset(bufnr, "n", "<leader>cd", function()
    vim.cmd.RustLsp("debuggables")
  end, "Rust debuggables")

  lsp_util.buf_kset(bufnr, "n", "<leader>cR", function()
    vim.cmd.RustLsp("runnables")
  end, "Rust runnables")

  lsp_util.buf_kset(bufnr, "n", "<leader>cT", function()
    vim.cmd.RustLsp("testables")
  end, "Rust testables")

  lsp_util.buf_kset(bufnr, "n", "<leader>ct", function()
    vim.cmd.RustLsp { "testables", bang = true }
  end, "Run previous test")

  lsp_util.buf_kset(bufnr, "n", "gc", function()
    vim.cmd.RustLsp("openCargo")
  end, "Open Cargo.toml")

  lsp_util.buf_kset(bufnr, "n", "gm", function()
    vim.cmd.RustLsp("parentModule")
  end, "Parent module")
end
