vim.cmd.colorscheme "catppuccin"

require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  dim_inactive = {
    enabled = true, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
})
