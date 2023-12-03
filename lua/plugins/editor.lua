return {
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<F9>",   vim.cmd.NvimTreeToggle,   desc = "NvimTree" },
      { "<S-F9>", vim.cmd.NvimTreeFindFile, desc = "NvimTree Find File" },
    },
    opts = {
      sort = {
        sorter = "case_sensitive",
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    },
    config = function(_, opts)
      -- disable netrw when nvim-tree loads
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      require("nvim-tree").setup(opts)
    end,
  },

  -- beautitul icons
  {
    "nvim-tree/nvim-web-devicons",
  }
}
