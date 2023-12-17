
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

-- Here is where you configure the autocompletion settings.
local lsp_zero = require("lsp-zero")
lsp_zero.extend_cmp()

-- And you can configure cmp even more, if you want to.
-- local cmp_action = lsp_zero.cmp_action()

local luasnip = require("luasnip")
local cmp = require("cmp")

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  formatting = lsp_zero.cmp_format(),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  ---@diagnostic disable-next-line: missing-fields
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
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
    -- ["<Tab>"] = vim.schedule_wrap(function(fallback)
    --   if cmp.visible() and has_words_before() then
    --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --   elseif luasnip.expand_or_locally_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end),
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
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    -- First index sources
    { name = "crates" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "treesitter" },
  }, {
    -- Second index sources
    { name = "copilot" },
    { name = "buffer" },
    { name = "emoji" },
    { name = "tmux" },
  }),
  cmdline = {
    enable = true,
    options = {
      {
        type = ":",
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      },
      {
        type = { "/", "?" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      },
    },
  },
})
