vim.bo.textwidth = 72

local cmp = require("cmp")

cmp.setup.buffer({
  sources = cmp.config.sources({
    { name = "conventionalcommits" },
    { name = "path" },
    { name = "buffer" },
  }),
})
