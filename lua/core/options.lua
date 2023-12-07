local g = vim.g
local o = vim.opt

g.mapleader      = " "
g.maplocalleader = "\\"

-- General

-- persistent undo
o.undofile   = true
o.undolevels = 10000

-- increase commands history
o.history = 1000

-- creates a backup file
o.backup      = false 
-- if a file is being edited by another program, or was written to file while
-- editing with another program, it is not allowed to be edited
o.writebackup = false 

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

o.autowrite = true -- enable auto write
o.autoread  = true -- read files modified outside of vim

-- required to keep multiple buffers and open multiple buffers
o.hidden = true

-- allows neovim to access the system clipboard 
o.clipboard = "unnamedplus"

-- sends more characters to terminal, improving window redraw
o.ttyfast = true

-- Global timeout settings (also affects which-key response time)
o.timeout    = true
o.timeoutlen = 300

-- Formatting

-- indentation
o.tabstop     = 2
o.softtabstop = 2
o.shiftwidth  = 2
o.shiftround  = true  -- round indent
o.expandtab   = true  -- use spaces instead of tabs
o.smarttab    = true  -- smarter tab levels
o.smartindent = true  -- smart (language based) auto indent
o.autoindent  = true  -- copy indent from current line when starting a new line

o.wrap      = false -- disable line wrap
o.textwidth = 0     -- don't wrap lines by default

-- don't break wrapped lines on words
o.linebreak = true

-- file type detection
o.filetype        = "on"        -- auto detect the type of file that is being edited
o.filetype.indent = "on" -- enable file type detection
o.filetype.plugin = "on" -- enable filetype-based indentation

-- sets the default file encoding
o.fileencoding = "utf-8"

-- Visual

-- enable 24 bit terminal colors
o.termguicolors = true

-- tells Nvim what the inherited Terminal colors are
o.background = "dark"

o.ruler       = true -- show ruler
o.number      = true -- show line numbers
o.cursorline  = true -- highlights the current line
o.laststatus  = 2    -- always display the status line
o.colorcolumn = "80"

-- always show the signcolumn, otherwise it would shift the text each time
o.signcolumn  = "yes"

o.showmatch = true -- show matching brackets
o.matchtime = 5    -- bracket blinking

-- display an incomplete command in the lower right corner of the Vim window
o.showcmd   = true
-- shortens messages
--o.shortmess = "atI"
-- more space in the neovim command line for displaying messages
o.cmdheight = 1
-- enhanced command line completion
o.wildmenu = true
-- at command line, complete longest common string, then list alternatives
o.wildmode = "longest,list"

-- set completeopt to have a better completion experience
o.completeopt = "menuone,noselect"

-- display unprintable characters by default
o.list      = true
-- use the same symbols as TextMate for tabstops and EOLs
o.listchars = "tab:▸ ,eol: ,trail:·,extends:»,precedes:«"

-- Mouse
if vim.fn.has("mouse") then
  o.mouse      = "a"      -- enable mouse
  o.mousehide  = true     -- hide mouse after chars typed
  o.mousemodel = "popup"  -- right mouse button pops up a menu
  o.scrolloff  = 3        -- show 3 lines of context around the cursor
end

o.pumblend = 10 -- Popup transparency

-- Splits
o.splitbelow = true     -- put new windows below current
o.splitright = true     -- put new windows right of current
o.splitkeep  = "screen" -- keep the cursor on the same screen line

-- Match and search
o.hlsearch   = true      -- highlight search
o.ignorecase = true      -- do case in sensitive matching with
o.smartcase  = true      -- be sensitive when there's a capital letter
o.incsearch  = true      -- highlight matches as you type
o.inccommand = "nosplit" -- preview incremental substitute

-- Integrations

if vim.fn.executable("rg") then
  o.grepprg = "rg --vimgrep"
end
