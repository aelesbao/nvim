vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt

o.backspace = "2"
o.showcmd = true
o.laststatus = 2
o.autowrite = true
o.cursorline = true
o.autoread = true
o.number = true

-- use spaces for tabs
o.tabstop = 2
o.shiftwidth = 2
o.shiftround = true
o.expandtab = true

-- enable 24 bit terminal colors
o.termguicolors = true

