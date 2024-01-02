return {
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = {
          name = "+goto",
          ["~"] = "Toggle case",
          ["u"] = "Lower case",
          ["U"] = "Upper case",
        },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>"] = {
          ["<tab>"] = { name = "+tabs" },
          ["b"] = { name = "+buffer" },
          ["c"] = { name = "+code" },
          ["e"] = { name = "+explorer" },
          ["f"] = { name = "+file/find" },
          ["g"] = {
            name = "+git",
            ["h"] = "hunks",
            ["t"] = "toggle",
          },
          ["q"] = { name = "+quit/session" },
          ["s"] = { name = "+search" },
          ["u"] = { name = "+ui" },
          ["w"] = { name = "+windows" },
          ["x"] = { name = "+diagnostics/quickfix" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
