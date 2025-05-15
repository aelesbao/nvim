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
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>a",     group = "AI" },
        { "<leader>b",     group = "buffer" },
        { "<leader>c",     group = "code" },
        { "<leader>d",     group = "debug" },
        { "<leader>e",     group = "explorer" },
        { "<leader>f",     group = "file/find" },
        { "<leader>g",     group = "git" },
        { "<leader>gh",    desc = "hunks" },
        { "<leader>gt",    desc = "toggle" },
        { "<leader>q",     group = "quit/session" },
        { "<leader>s",     group = "search" },
        { "<leader>t",     group = "test" },
        { "<leader>u",     group = "ui" },
        { "<leader>w",     group = "windows" },
        { "<leader>x",     group = "diagnostics/quickfix" },
        { "[",             group = "prev" },
        { "]",             group = "next" },
        { "g",             group = "goto" },
        { "gx",            group = "trouble" },
        { "gU",            desc = "Upper case" },
        { "gu",            desc = "Lower case" },
        { "g~",            desc = "Toggle case" },
      },
    },
  },
}
