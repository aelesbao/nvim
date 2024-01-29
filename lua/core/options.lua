vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- General
local opt            = vim.opt

-- persistent undo
opt.undofile         = true
opt.undolevels       = 10000

-- increase commands history
opt.history          = 1000

-- creates a backup file
opt.backup           = false
-- if a file is being edited by another program, or was written to file while
-- editing with another program, it is not allowed to be edited
opt.writebackup      = false

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime       = 250

opt.autowriteall     = true -- enable auto write
opt.autoread         = true -- read files modified outside of vim

-- required to keep multiple buffers and open multiple buffers
opt.hidden           = true

-- sends more characters to terminal, improving window redraw
opt.ttyfast          = true

-- Global timeout settings (also affects which-key response time)
opt.timeout          = true
opt.timeoutlen       = 300

-- Formatting

-- indentation
opt.tabstop          = 2
opt.softtabstop      = 2
opt.shiftwidth       = 2
opt.shiftround       = true -- round indent
opt.expandtab        = true -- use spaces instead of tabs
opt.smarttab         = true -- smarter tab levels
opt.smartindent      = true -- smart (language based) auto indent
opt.autoindent       = true -- copy indent from current line when starting a new line

-- text wrapping
opt.linebreak        = true  -- don't break wrapped lines on words
opt.textwidth        = 0     -- don't wrap lines by default
opt.wrap             = false -- disable line wrap

-- file
opt.filetype         = "on"    -- auto detect the type of file being edited
opt.fileencoding     = "utf-8" -- sets the default file encoding

-- Visual

-- enable 24 bit terminal colors
opt.termguicolors    = true

-- tells Nvim what the inherited Terminal colors are
opt.background       = "dark"

opt.ruler            = true -- show ruler
opt.number           = true -- show line numbers
opt.cursorline       = true -- highlights the current line
opt.laststatus       = 3    -- always display the status line
opt.colorcolumn      = "+0"

-- always show the signcolumn, otherwise it would shift the text each time
opt.signcolumn       = "yes"

opt.showmatch        = true -- show matching brackets
opt.matchtime        = 5    -- bracket blinking

-- display an incomplete command in the lower right corner of the Vim window
opt.showcmd          = true
-- shortens messages
--o.shortmess = "atI"
-- more space in the neovim command line for displaying messages
opt.cmdheight        = 1
-- enhanced command line completion
opt.wildmenu         = true
-- at command line, complete longest common string, then list alternatives
opt.wildmode         = "longest,list"

-- set completeopt to have a better completion experience
opt.completeopt      = "menu,menuone,noinsert,noselect"

-- display unprintable characters by default
opt.list             = true
-- use the same symbols as TextMate for tabstops and EOLs
opt.listchars        = {
  tab = "▸ ",
  eol = " ",
  trail = "·",
  extends = "»",
  precedes = "«",
}

-- Mouse
if vim.fn.has("mouse") then
  opt.mouse      = "a"     -- enable mouse
  opt.mousehide  = true    -- hide mouse after chars typed
  opt.mousemodel = "popup" -- right mouse button pops up a menu
  opt.scrolloff  = 5       -- always show X lines of context around the cursor
end

opt.pumblend         = 10 -- Popup transparency

-- Splits
opt.splitbelow       = true     -- put new windows below current
opt.splitright       = true     -- put new windows right of current
opt.splitkeep        = "screen" -- keep the cursor on the same screen line

-- Match and search
opt.hlsearch         = true      -- highlight search
opt.ignorecase       = true      -- do case in sensitive matching with
opt.smartcase        = true      -- be sensitive when there's a capital letter
opt.incsearch        = true      -- highlight matches as you type
opt.inccommand       = "nosplit" -- preview incremental substitute

-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,localoptions,tabpages,terminal,winpos,winsize"
vim.o.sessionoptions = "blank,buffers,curdir,folds,localoptions,tabpages,terminal,winpos,winsize"

-- Integrations

if vim.fn.executable("rg") then
  opt.grepprg = "rg --vimgrep"
end

-- Make sure EditorConfig integration is loaded
vim.g.editorconfig = true
