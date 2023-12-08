local function augroup(name)
  return vim.api.nvim_create_augroup("local_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "VimResized" }, {
  desc = "resize splits if window got resized",
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd({ "BufWritePre" }, {
  desc = "auto create dir when saving a file, in case some intermediate directory does not exist",
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd("BufReadPost", {
  desc = "go to last loc when opening a buffer",
  group = augroup("last_loc"),
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

autocmd("FileType", {
  desc = "close some filetypes with <q>",
  group = augroup("close_with_q"),
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

local line_lengths = {
  gitcommit = 72,
  markdown  = 80
}

autocmd("FileType", {
  desc = "wrap and check for spell in text filetypes",
  group = augroup("wrap_width_spell"),
  pattern = vim.tbl_keys(line_lengths),
  callback = function()
    vim.opt_local.wrap  = true
    vim.opt_local.spell = true
    vim.opt_local.textwidth = line_lengths[vim.opt.filetype]
  end,
})
