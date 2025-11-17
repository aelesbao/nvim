vim.bo.textwidth = 120

local utils = require("utils")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_config_rust", { clear = true }),
  callback = function(event)
    local kset = utils.buf_kset(event.buf)

    -- kset({ "n" }, "gra", ":RustLsp codeAction<cr>", "Code action")
    -- kset({ "n", "i" }, "<M-CR>", function()
    --   vim.cmd.RustLsp { "codeAction" }
    -- end, "Code action")

    kset("n", "K", ":RustLsp hover actions<cr>", "Hover actions")

    -- kset("n", "<leader>cf", ":RustFmt<cr>", "rustfmt")

    kset("n", "<leader>cd", ":RustLsp debuggables<cr>", "Rust debuggables")
    kset("n", "<leader>cR", ":RustLsp runnables<cr>", "Rust runnables")
    kset({ "n", "x", "i" }, "<M-R>", function()
      vim.cmd.RustLsp { "runnables", bang = true }
    end, "Run last runnable")
    kset("n", "<leader>tT", ":RustLsp testables<cr>", "Rust testables")

    kset("n", "<leader>xe", ":RustLsp explainError<cr>", "Explain error")
    kset("n", "<leader>xr", ":RustLsp renderDiagnostic<cr>", "Render diagnostic")

    kset("n", "gk", ":RustLsp openDocs<cr>", "Open docs.rs")
    kset("n", "gC", ":RustLsp openCargo<cr>", "Open Cargo.toml")
    kset("n", "gp", ":RustLsp parentModule<cr>", "Parent module")
  end,
})
