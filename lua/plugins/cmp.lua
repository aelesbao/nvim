return {
  -- autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- snippet Engine & its associated nvim-cmp source
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",

      -- adds a number of user-friendly snippets
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup({
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
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
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
        sources = {
          { name = "buffer" },
          { name = "crates" },
          { name = "emoji" },
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "tmux" },
          { name = "treesitter" },
        },
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
    end
  },

  {
    "L3MON4D3/LuaSnip",
    opts = {},
    config = function(_, opts)
      local luasnip = require("luasnip")

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      -- lua format
      require("luasnip.loaders.from_lua").load()

      luasnip.config.setup(opts)
    end
  },

  -- adds LSP completion capabilities
  {
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end
  },
}
