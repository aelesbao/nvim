local u = require("utils")

local cursorline_group = u.augroup("cursorline")
u.create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  desc = "enable cursor line highlight for the current window",
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = true
  end,
})
u.create_autocmd("WinLeave", {
  desc = "disable cursor line highlight when leaving the window",
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})

u.create_autocmd("VimResized", {
  desc = "resize splits if window got resized",
  group = u.augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

u.create_autocmd("BufWritePre", {
  desc = "auto create dir when saving a file, in case some intermediate directory does not exist",
  group = u.augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

u.create_autocmd("BufReadPost", {
  desc = "go to last location when opening a buffer",
  group = u.augroup("last_location"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

u.create_autocmd("FileType", {
  desc = "close some filetypes with <q>",
  group = u.augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

u.create_autocmd("FileType", {
  desc = "wrap and check for spell in text filetypes",
  group = u.augroup("wrap_width_spell"),
  pattern = {
    "gitcommit",
    "markdown",
  },
  callback = function()
    vim.opt_local.wrap  = true
    vim.opt_local.spell = true
  end,
})

-- NOTE: fixes transparent bg for ghostty on macOS
-- https://github.com/ghostty-org/ghostty/discussions/3579#discussioncomment-11680090
if vim.fn.has("mac") == 1 then
  u.create_autocmd("ColorScheme", {
    desc = "fix transparent background on macOS",
    group = u.augroup("transparent_backaground"),
    pattern = "*",
    callback = function()
      local hl_groups = {
        "Normal",
        "NonText",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
      }

      for _, group in ipairs(hl_groups) do
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        if hl and hl.bg then
          hl.bg = nil
          vim.api.nvim_set_hl(0, group, hl)
        end
      end
    end
  })
end
