local cmp = require("cmp")

cmp.setup.buffer({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "crates" },
    { name = "copilot" },
  }, {
    { name = "path" },
    { name = "buffer" },
  }),
})

local lsp_util = require("plugins.lsp.util")
local bufnr = vim.api.nvim_get_current_buf()

lsp_util.buf_kset(bufnr, "n", "K", function()
  if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end, "Show Crate documentation")
