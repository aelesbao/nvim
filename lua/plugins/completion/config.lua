local function has_words_before()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

cmp.setup({
  formatting = {
    expandable_indicator = true,
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
      max_width = 50,
      symbol_map = {
        Copilot = "",
      },
    }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      -- Inserts suggestion before the next word
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
    ["<S-CR>"] = cmp.mapping.confirm({
      -- Replaces the next word with suggestion
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<PageUp>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Select,
      count = 4,
    }),
    ["<PageDown>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select,
      count = 4,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "path" },
    { name = "buffer" },
  }),
  experimental = {
    ghost_text = false,
  },
})

cmp.setup.cmdline(":", {
  completion = {
    keyword_length = 3,
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    {
      name = "cmdline",
      option = {
        ignore_cmds = { "Man", "!" },
      },
    },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  completion = {
    keyword_length = 3,
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.event:on("menu_opened", function()
  ---@diagnostic disable-next-line: inject-field
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  ---@diagnostic disable-next-line: inject-field
  vim.b.copilot_suggestion_hidden = false
end)

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
vim.lsp.config('*', { capabilities = capabilities, })
