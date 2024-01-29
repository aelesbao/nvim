vim.bo.textwidth = 120

local cmp = require("cmp")

cmp.setup.buffer({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "copilot", },
  }, {
    { name = "path" },
    { name = "buffer" },
  }),
})
