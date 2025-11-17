local utils = require("utils")

utils.create_autocmd("LspAttach", {
  group = utils.augroup("lsp_config_dotenv"),
  pattern = { ".env", ".env.*" },
  callback = function(event)
    -- diusable diagnostics for dotenv files
    vim.diagnostic.enable(false, { bufnr = event.buf })
  end
})
