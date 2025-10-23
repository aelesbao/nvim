return {
  -- allow lazy.nvim to manage itself
  {
    "folke/lazy.nvim",
    tag = "stable",
    init = function()
      vim.keymap.set("n", "<leader>l", ":Lazy<cr>", { desc = "Lazy" })
    end
  },
}
