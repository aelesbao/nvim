local k = vim.keymap

-- too lazy to hold shift
k.set({'n', 'v'}, ";", ":", { noremap = true })

-- clears the search register
k.set("n", "<leader>/", ":nohlsearch<cr>")

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

-- keep current buffer after pasting or deleting
k.set("x",        "<leader>p", [["_dP]])
k.set({"n", "v"}, "<leader>d", [["_d]])

-- Hard-wrap paragraphs of text
k.set("n", "<leader>=", "gqip")

-- show/hide hidden chars
k.set("n", "<F12>", ":set invlist<cr>", { silent = true })

-- Buffers
-- switch to last used buffer
k.set("n", "<leader>l", ":e#<cr>")
-- open last used buffer in vertical split
k.set("n", "<leader>v", ":vsplit#<cr>")

--k.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
