local M = {}

function M.buf_kset(bufnr, mode, lhs, rhs, desc)
  if mode == nil then
    return function(...) M.buf_kset(bufnr, ...) end
  end

  local opts = { buffer = bufnr, desc = desc, remap = true, silent = true, }
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.augroup(name)
  return vim.api.nvim_create_augroup("local_" .. name, { clear = true })
end

---Create an autocommand in Neovim
---@param autocmd string|table The autocmd event(s) to trigger the command
---@param opts {group: string|integer, buffer: number|nil, pattern: string|table|nil, callback: function|string} Optional parameters for the autocmd
---@return nil
function M.create_autocmd(autocmd, opts)
  opts = opts or {}

  -- Pattern takes precedence over buffer
  if opts.pattern and opts.buffer then
    opts.buffer = nil
  end

  vim.api.nvim_create_autocmd(autocmd, {
    group = opts.group,
    buffer = opts.buffer,
    pattern = opts.pattern,
    callback = type(opts.callback) == "function" and opts.callback or function()
      vim.cmd(opts.callback)
    end,
  })
end

return M
