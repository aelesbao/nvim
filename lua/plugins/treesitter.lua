-- on main branch, treesitter isn't started automatically
vim.api.nvim_create_autocmd({ "Filetype" }, {
  callback = function(event)
    -- make sure nvim-treesitter is loaded
    local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

    -- no nvim-treesitter, maybe fresh install
    if not ok then return end

    local parsers = require("nvim-treesitter.parsers")

    if not parsers[event.match] or not nvim_treesitter.install then return end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    nvim_treesitter.install({ lang }):await(function(err)
      if err then
        vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
        return
      end

      pcall(vim.treesitter.start, event.buf)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end)
  end,
})

return {
  -- highlight, edit, and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- last release is way too old and doesn't work on Windows
    dependencies = {
      -- wisely add "end". tree-sitter aware alternative to tpope's vim-endwise
      --"RRethy/nvim-treesitter-endwise",
      -- refactor modules for nvim-treesitter
      --"nvim-treesitter/nvim-treesitter-refactor",
      { "folke/ts-comments.nvim", opts = {} },
    },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSInstall",
      "TSInstallFromGrammar",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = function()
      -- update parsers, if TSUpdate exists
      if vim.fn.exists(":TSUpdate") == 2 then vim.cmd("TSUpdate") end
    end,
    config = function(_, _)
      local ensure_installed = {
        "bash",
        "c",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rust",
        "ssh_config",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      -- make sure nvim-treesitter can load
      local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

      -- no nvim-treesitter, maybe fresh install
      if not ok then return end

      nvim_treesitter.install(ensure_installed)
    end,
  },

  --  -- syntax aware text-objects, select, move, swap, and peek support
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    keys = {
      {
        "[f",
        function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,
        desc = "prev function",
        mode = { "n", "x", "o" },
      },
      {
        "]f",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
        desc = "next function",
        mode = { "n", "x", "o" },
      },
      {
        "[F",
        function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end,
        desc = "prev function end",
        mode = { "n", "x", "o" },
      },
      {
        "]F",
        function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
        desc = "next function end",
        mode = { "n", "x", "o" },
      },
      {
        "[a",
        function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects") end,
        desc = "prev argument",
        mode = { "n", "x", "o" },
      },
      {
        "]a",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects") end,
        desc = "next argument",
        mode = { "n", "x", "o" },
      },
      {
        "[A",
        function() require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects") end,
        desc = "prev argument end",
        mode = { "n", "x", "o" },
      },
      {
        "]A",
        function() require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects") end,
        desc = "next argument end",
        mode = { "n", "x", "o" },
      },
      {
        "[s",
        function() require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects") end,
        desc = "prev block",
        mode = { "n", "x", "o" },
      },
      {
        "]s",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects") end,
        desc = "next block",
        mode = { "n", "x", "o" },
      },
      {
        "[S",
        function() require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects") end,
        desc = "prev block",
        mode = { "n", "x", "o" },
      },
      {
        "]S",
        function() require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects") end,
        desc = "next block",
        mode = { "n", "x", "o" },
      },
      {
        "gan",
        function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,
        desc = "swap next argument",
      },
      {
        "gap",
        function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end,
        desc = "swap prev argument",
      },
    },

    opts = {
      move = {
        enable = true,
        set_jumps = true,
      },
      swap = {
        enable = true,
      },
    },
  },

  --  -- automatically add closing tags for HTML and JSX
  --  {
  --    "windwp/nvim-ts-autotag",
  --    dependencies = {
  --      "nvim-treesitter/nvim-treesitter",
  --    },
  --    opts = {
  --      opts = {
  --        -- Defaults
  --        enable_close = true,          -- Auto close tags
  --        enable_rename = true,         -- Auto rename pairs of tags
  --        enable_close_on_slash = false -- Auto close on trailing </
  --      },
  --    }
  --  },
}
