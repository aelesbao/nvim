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
