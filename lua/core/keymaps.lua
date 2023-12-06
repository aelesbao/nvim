local k = vim.keymap

-- too lazy to hold shift
k.set({'n', 'v'}, ";", ":", { remap = false })

-- Tabs
k.set("n", "<S-Tab>", ":tabprevious<cr>")
k.set("n", "<Tab>",   ":tabnext<cr>")

-- smart join/split lines
k.set("n", "J", "mzJ`z")
k.set("n", "<C-j>", "gea<cr><esc>")

-- centralize the screen on scroll up/down or search next/previous
k.set("n", "<C-d>", "<C-d>zz")
k.set("n", "<C-u>", "<C-u>zz")
k.set("n", "n", "nzzzv")
k.set("n", "N", "Nzzzv")

-- Text manipulation
k.set("x",        "<leader>p", [["_dP]], { desc = "Paste and keep the current buffer" })
k.set({"n", "v"}, "<leader>d", [["_d]],  { desc = "Delete and keep the current buffer" })
k.set("n",        "<leader>=", "gqip",   { desc = "Hard-wrap paragraphs of text" })

-- show/hide hidden chars
k.set("n", "<F12>", ":set invlist<cr>", { silent = true })

-- search
k.set("n", "<leader>/", ":nohlsearch<cr>", { desc = "Clears the search register" })

-- Buffers
k.set("n", "<leader>bl", ":e#<cr>",      { desc = "Switch to last used buffer" })
k.set("n", "<leader>bv", ":vsplit#<cr>", { desc = "Open last used buffer in vertical split" })

--k.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
