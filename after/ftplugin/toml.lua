local cmp = require("cmp")

cmp.setup.buffer({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "crates" },
    {
      name = "copilot",
      keyword_length = 3,
      max_item_count = 3,
    },
  }, {
    { name = "path" },
    { name = "buffer" },
  }),
})
