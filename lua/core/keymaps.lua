local k = vim.keymap

-- too lazy to hold shift
k.set({ "n", "v" }, ";", ":", { remap = false })

-- jump to the beginning and end of word
k.set("i", "<Esc>b", "<C-Left>")
k.set("i", "<Esc>f", "<C-Right>")
-- jump to the beginning and end of line
k.set("i", "<C-a>", "<Home>", { remap = false })
k.set("i", "<C-e>", "<End>", { remap = false })

-- Tabs
k.set("n", "<s-tab>", ":tabprevious<cr>")
k.set("n", "<tab>", ":tabnext<cr>")
k.set("n", "<leader><tab>q", ":tabclose<cr>", { desc = "Close tab" })
k.set("n", "<leader><tab>Q", ":tabonly<cr>", { desc = "Close other tabs" })
k.set("n", "<leader><tab><", ":tabm -1<cr>", { desc = "Move tab prev" })
k.set("n", "<leader><tab>>", ":tabm +1<cr>", { desc = "Move tab next" })

-- smart join/split lines
k.set("n", "J", "mzJ`z")
k.set("n", "<C-j>", "gea<cr><esc>")

k.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
k.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- centralize the screen on scroll up/down or search next/previous
k.set("n", "<C-d>", "<C-d>zz")
k.set("n", "<C-u>", "<C-u>zz")
k.set("n", "<C-f>", "<C-f>zz")
k.set("n", "<C-b>", "<C-b>zz")
k.set("n", "n", "nzzzv")
k.set("n", "N", "Nzzzv")

-- Text manipulation
k.set("n", "<leader>=", "gqip", { desc = "Hard-wrap paragraphs of text" })

k.set("x", "<leader>p", [["_dP]], { desc = "Paste and keep the current buffer" })
k.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete and keep the current buffer" })

k.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
k.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })

k.set("n", "<M-d>", "Yp", { desc = "Duplicate line" })

-- show/hide hidden chars
k.set("n", "<F12>", ":set invlist<cr>", { silent = true })

-- search
k.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Search and replace the current text"
})

-- Buffers
k.set("n", "<leader>bl", ":e#<cr>", { desc = "Switch to last used buffer" })
k.set("n", "<leader>bv", ":vsplit#<cr>", { desc = "Open last used buffer in vertical split" })
