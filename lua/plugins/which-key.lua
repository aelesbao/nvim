return {
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      preset = "modern",
      sort = { "group", "local", "order", "alphanum", "mod" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>b",     group = "buffer" },
        { "<leader>c",     group = "code" },
        { "<leader>e",     group = "explorer" },
        { "<leader>f",     group = "file/find" },
        { "<leader>g",     group = "git" },
        { "<leader>gh",    group = "git hunks" },
        { "<leader>gt",    group = "git toggle" },
        { "<leader>q",     group = "quit/session" },
        { "<leader>s",     group = "search" },
        { "<leader>t",     group = "test" },
        { "<leader>u",     group = "ui" },
        { "<leader>w",     group = "workspaces" },
        { "<leader>x",     group = "diagnostics/quickfix" },
        { "<leader>z",     group = "zen" },
        { "[",             group = "prev" },
        { "]",             group = "next" },
        { "g",             group = "goto" },
        { "gx",            group = "trouble" },
        { "gU",            desc = "Upper case" },
        { "gu",            desc = "Lower case" },
        { "g~",            desc = "Toggle case" },
      })
    end,
  },
}
