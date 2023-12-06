return {
  -- highlight, edit, and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
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
    event = "User FileOpened",
    build = ":TSUpdate",
    opts = {
      -- A list of parser names, or "all"
      ensure_installed = {
        "bash",
        "c",
        "dockerfile",
        "git_config",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "make",
        "python",
        "query",
        "rust",
        "ssh_config",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = vim.fn.executable("tree-sitter") == 1,

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      -- indentation for the = operator (experimental)
      indent = {
        enable = true,
      },  
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- syntax aware text-objects, select, move, swap, and peek support
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- visualize the AST parsed by Treesitter
  {
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- shows the context of the currently visible buffer contents
  {
    "nvim-treesitter/nvim-treesitter-context",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      { "[c", function()
        require("treesitter-context").go_to_context()
      end, silent = true, desc = "Go to upward context" },
    }
  },

  -- https://github.com/RRethy/nvim-treesitter-endwise
}
