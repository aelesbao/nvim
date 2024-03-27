local lsp_util = require("plugins.lsp.util")

return {
  {
    "saecki/crates.nvim",
    tag = "stable",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    opts = {
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
    ft = { "rust" },
    dependencies = {
      "nvim-neotest/neotest",
      "mattn/webapi-vim",
    },
    ---@type RustaceanOpts
    opts = {
      -- Plugin configuration
      tools = {
        executor = "vimux",
        enable_clippy = true,
        enable_nextest = true,
      },
      -- LSP configuration
      server = {
        on_attach = function(_, bufnr)
          local function kset(...) lsp_util.buf_kset(bufnr, ...) end

          kset({ "n" }, "<leader>ca", ":RustLsp codeAction<cr>", "Code action")
          kset({ "n", "i" }, "<M-CR>", ":RustLsp codeAction<cr>", "Code action")

          kset("n", "K", ":RustLsp hover actions<cr>", "Hover actions")

          kset("n", "<leader>ce", ":RustLsp explainError<cr>", "Explain error")
          kset("n", "<leader>cx", ":RustLsp renderDiagnostic<cr>", "Render diagnostic")

          kset("n", "<leader>cd", ":RustLsp debuggables<cr>", "Rust debuggables")
          kset("n", "<leader>cR", ":RustLsp runnables<cr>", "Rust runnables")
          kset("n", "<leader>tT", ":RustLsp testables<cr>", "Rust testables")

          kset("n", "gK", ":RustLsp openDocs<cr>", "Open docs.rs")
          kset("n", "gC", ":RustLsp openCargo<cr>", "Open Cargo.toml")
          kset("n", "gp", ":RustLsp parentModule<cr>", "Parent module")
        end,

        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
            },
            check = {
              features = "all",
            },
            hover = {
              actions = {
                references = {
                  enable = true,
                },
              }
            },
            imports = {
              preferPrelude = true,
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
      -- dap = {
      -- },
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
