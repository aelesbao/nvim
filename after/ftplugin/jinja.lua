-- If Neovim's Tree-sitter syntax highlighting is active regular syntax
-- highlighting will be disabled. This means for example that if you edit
-- a html.jinja file and you have the Tree-sitter HTML parser installed the
-- regular highlighting for Jinja will be disabled. If you want to have both
-- Tree-sitter highlighting for HTML and regular highlighting for Jinja in
-- your buffer you need to set syntax=on for that buffer.

-- only do this once per buffer
if not vim.b.jinja_syntax_autocmd_loaded then
  -- if there’s no Tree-sitter grammar for Jinja…
  if vim.treesitter.language.get_lang("jinja") == nil then
    vim.api.nvim_create_autocmd("FileType", {
      -- make it buffer-local
      buffer = 0,
      callback = function()
        -- once &ft is set, turn on syntax highlighting
        if vim.bo.filetype ~= "" then
          vim.opt_local.syntax = "on"
        end
      end,
    })
  end
  vim.b.jinja_syntax_autocmd_loaded = true
end
