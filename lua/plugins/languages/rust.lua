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
          lsp_util.buf_kset(bufnr, "n", "<C-space>", function()
            vim.cmd.RustLsp { "hover", "actions" }
          end, "Hover actions")

          lsp_util.buf_kset(bufnr, "n", "<leader>ch", function()
            vim.cmd.RustLsp { "hover", "actions" }
          end, "Hover actions")

          lsp_util.buf_kset(bufnr, "n", "<leader>ca", function()
            vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
            -- or vim.lsp.buf.codeAction() if you don't want grouping.
          end, "Code actions")

          lsp_util.buf_kset(bufnr, "n", "<leader>ce", function()
            vim.cmd.RustLsp("explainError")
          end, "Explain error")

          lsp_util.buf_kset(bufnr, "n", "<leader>cx", function()
            vim.cmd.RustLsp("renderDiagnostic")
          end, "Render diagnostic")

          lsp_util.buf_kset(bufnr, "n", "<leader>cd", function()
            vim.cmd.RustLsp("debuggables")
          end, "Rust debuggables")

          lsp_util.buf_kset(bufnr, "n", "<leader>cR", function()
            vim.cmd.RustLsp("runnables")
          end, "Rust runnables")

          lsp_util.buf_kset(bufnr, "n", "<leader>cT", function()
            vim.cmd.RustLsp("testables")
          end, "Rust testables")

          lsp_util.buf_kset(bufnr, "n", "<leader>ct", function()
            vim.cmd.RustLsp { "testables", bang = true }
          end, "Run previous test")

          lsp_util.buf_kset(bufnr, "n", "gc", function()
            vim.cmd.RustLsp("openCargo")
          end, "Open Cargo.toml")

          lsp_util.buf_kset(bufnr, "n", "gm", function()
            vim.cmd.RustLsp("parentModule")
          end, "Parent module")
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
