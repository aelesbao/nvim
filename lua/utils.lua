local M = {}

function M.buf_kset(bufnr, mode, lhs, rhs, desc)
  if mode == nil then
    return function(...) M.buf_kset(bufnr, ...) end
  end

  local opts = { buffer = bufnr, desc = desc, remap = true, silent = true, }
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
