return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.completion.spell.with({
          filetypes = { "markdown" },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.ansiblelint,
        null_ls.builtins.diagnostics.buf,
        null_ls.builtins.diagnostics.commitlint,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns.with({
          config = {
            filter_actions = function(title)
              return title:lower():match("blame") == nil -- filter out blame actions
            end,
          }
        }),
        null_ls.builtins.code_actions.shellcheck,
      },
    })
  end,
}
