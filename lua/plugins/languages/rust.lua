local lsp_util = require("plugins.lsp.util")

return {
  {
    "saecki/crates.nvim",
    tag = "stable",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    opts = {
      popup = {
        autofocus = true,
        show_version_date = true,
        show_dependency_version = true,
      },
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },

  -- Extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saecki/crates.nvim",
    },
    event = { "BufRead Cargo.toml" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
    end,
  },

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
    end,
  },

  -- Ensure Rust debugger is installed
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    lazy = false, -- This plugin is already lazy
    dependencies = {
      "nvim-neotest/neotest",
      "mattn/webapi-vim",
    },
    ---@type RustaceanOpts
    opts = {
      -- Plugin configuration
      tools = {
        executor = "vimux",
        enable_clippy = false, -- too slow
        enable_nextest = true,
        code_actions = {
          ui_select_fallback = true,
        },
        hover_actions = {
          replace_builtin_hover = false,
        },
      },
      -- LSP configuration
      server = {
        -- Standalone file support (enabled by default).
        -- Disabling it may improve rust-analyzer's startup time.
        standalone = false,
        -- Whether to search (upward from the buffer) for rust-analyzer settings in .vscode/settings json.
        -- If found, loaded settings will override configured options.
        load_vscode_settings = true,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              -- features = "all",
            },
            check = {
              -- features = "all",
            },
            imports = {
              preferPrelude = true,
            },
            inlayHints = {
              bindingModeHints = {
                enable = false
              },
              closureCaptureHints = {
                enable = false
              },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
      -- DAP configuration
      dap = {
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("rustaceanvim.neotest"),
      })
    end,
  },

}
