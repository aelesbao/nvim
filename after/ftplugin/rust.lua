vim.bo.textwidth = 120

local lsp_util = require("plugins.lsp.util")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_config_rust", { clear = true }),
  callback = function(event)
    local kset = lsp_util.buf_kset(event.buf)

    kset({ "n" }, "<leader>ca", ":RustLsp codeAction<cr>", "Code action")
    kset({ "n" }, "<M-CR>", ":RustLsp codeAction<cr>", "Code action")

    kset("n", "K", ":RustLsp hover actions<cr>", "Hover actions")

    kset("n", "<leader>cd", ":RustLsp debuggables<cr>", "Rust debuggables")
    kset("n", "<leader>cR", ":RustLsp runnables<cr>", "Rust runnables")
    kset({ "n", "v", "i" }, "<Esc>R", ":RustLsp! runnables<cr>", "Run last runnable")
    kset("n", "<leader>tT", ":RustLsp testables<cr>", "Rust testables")

    kset("n", "<leader>xe", ":RustLsp explainError<cr>", "Explain error")
    kset("n", "<leader>xr", ":RustLsp renderDiagnostic<cr>", "Render diagnostic")

    kset("n", "gK", ":RustLsp openDocs<cr>", "Open docs.rs")
    kset("n", "gC", ":RustLsp openCargo<cr>", "Open Cargo.toml")
    kset("n", "gp", ":RustLsp parentModule<cr>", "Parent module")
  end,
})
