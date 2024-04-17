local cmp = require("cmp")

cmp.setup.buffer({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "crates" },
    { name = "copilot" },
  }, {
    { name = "path" },
    { name = "buffer" },
  }),
})

local lsp_util = require("plugins.lsp.util")
local crates = require("crates")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_config_toml_crates", { clear = true }),
  pattern = "Cargo.toml",
  callback = function(event)
    local kset = lsp_util.buf_kset(event.buf)

    kset("n", "<leader>cT", crates.toggle, "Toggle crates.nvim")
    kset("n", "<leader>cR", crates.reload, "Reload data")

    kset("n", "<leader>ce", crates.expand_plain_crate_to_inline_table,
      "Expand plain declaration")
    kset("n", "<leader>cE", crates.extract_crate_into_table,
      "Extract from dependencies section")

    kset("n", "<leader>cu", crates.update_crate, "Update crate")
    kset("v", "<leader>cu", crates.update_crates, "Update crates")
    kset("n", "<leader>ca", crates.update_all_crates, "Update all crates")
    kset("n", "<leader>cU", crates.upgrade_crate, "Upgrade crate")
    kset("v", "<leader>cU", crates.upgrade_crates, "Upgrade crates")
    kset("n", "<leader>cA", crates.upgrade_all_crates, "Upgrade all crates")

    kset("n", "<leader>ch", crates.open_homepage, "Open homepage")
    kset("n", "<leader>cr", crates.open_repository, "Open repository")
    kset("n", "<leader>cd", crates.open_documentation, "Open documentation")
    kset("n", "gk", crates.open_documentation, "Open docs.rs")
    kset("n", "<leader>cC", crates.open_crates_io, "Open crates.io")

    -- if crates.popup_available() then
    kset("n", "K", crates.show_popup, "Show crate details")
    kset("n", "<leader>cv", crates.show_versions_popup, "Versions")
    kset("n", "<leader>cF", crates.show_features_popup, "Features")
    kset("n", "<leader>cD", crates.show_dependencies_popup, "Dependencies")
    -- end
  end,
})
