return {
  -- highlight, edit, and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    dependencies = {
      -- wisely add "end". tree-sitter aware alternative to tpope's vim-endwise
      "RRethy/nvim-treesitter-endwise",
      -- refactor modules for nvim-treesitter
      "nvim-treesitter/nvim-treesitter-refactor",
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
    event = "User FileOpened",
    build = ":TSUpdate",
    opts = {
      -- A list of parser names, or "all"
      ensure_installed = {
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

      -- selects text by context (like Ctrl+Up on IntelliJ)
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<M-Up>",
          node_incremental = "<M-Up>",
          scope_incremental = "<M-S-Up>",
          node_decremental = "<M-Down>",
        },
      },

      -- enables RRethy/nvim-treesitter-endwise
      endwise = {
        enable = true,
      },

      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
        highlight_current_scope = {
          enable = true,
        },
      }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end,
  },

  -- syntax aware text-objects, select, move, swap, and peek support
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      opts = {
        -- Defaults
        enable_close = true,          -- Auto close tags
        enable_rename = true,         -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
      },
    }
  },
}
