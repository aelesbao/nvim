---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  -- Debugging support. Requires language specific adapters to be configured.
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },

      -- which key integration
      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          defaults = {
            ["<leader>d"] = { name = "+debug" },
          },
        },
      },

      -- mason.nvim integration
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = false,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },

      -- VsCode launch.json parser
      {
        "folke/neoconf.nvim",
      },
    },

    keys = function()
      local dap = require("dap")
      return {
        { "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() dap.toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
        { "<leader>dc", function() dap.continue() end,                                             desc = "Continue" },
        { "<leader>da", function() dap.continue({ before = get_args }) end,                        desc = "Run with Args" },
        { "<leader>dl", function() dap.run_last() end,                                             desc = "Run Last" },
        { "<leader>dC", function() dap.run_to_cursor() end,                                        desc = "Run to Cursor" },
        { "<leader>dg", function() dap.goto_() end,                                                desc = "Go to Line (No Execute)" },
        { "<leader>dj", function() dap.down() end,                                                 desc = "Down" },
        { "<leader>dk", function() dap.up() end,                                                   desc = "Up" },
        { "<leader>dO", function() dap.step_over() end,                                            desc = "Step Over" },
        { "<leader>di", function() dap.step_into() end,                                            desc = "Step Into" },
        { "<leader>do", function() dap.step_out() end,                                             desc = "Step Out" },
        { "<leader>dp", function() dap.pause() end,                                                desc = "Pause" },
        { "<leader>dr", function() dap.repl.toggle() end,                                          desc = "Toggle REPL" },
        { "<leader>ds", function() dap.session() end,                                              desc = "Session" },
        { "<leader>dt", function() dap.terminate() end,                                            desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end,                          desc = "Widgets" },
        -- IntelliJ IDEA style stepping
        { "<F5>",       function() dap.continue() end,                                             desc = "Continue" },
        { "<F7>",       function() dap.step_into() end,                                            desc = "Step Into" },
        { "<C-F8>",     function() dap.toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
        { "<F8>",       function() dap.step_over() end,                                            desc = "Step Over" },
        { "<M-F9>",     function() dap.run_to_cursor()() end,                                      desc = "Run to Cursor" },
        { "<S-F7>",     function() dap.step_out() end,                                             desc = "Step Out" },
      }
    end,

    config = function()
      local hl = vim.api.nvim_set_hl
      local colors = require("tokyonight.colors").setup()
      local util = require("tokyonight.util")
      hl(0, "DapBreakpointColor", { fg = colors.red1 })
      hl(0, "DapBreakpointLine", { bg = util.darken(colors.red1, 0.2) })
      hl(0, "DapStoppedColor", { fg = colors.blue0 })

      vim.fn.sign_define("DapBreakpoint", {
        text = "", texthl = "DapBreakpointColor", linehl = "DapBreakpointLine"
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "", texthl = "DapBreakpointColor", linehl = "DapBreakpointLine"
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "", texthl = "DapBreakpointColor", linehl = ""
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "", texthl = "DapBreakpointColor", linehl = ""
      })
      vim.fn.sign_define("DapStopped", {
        text = "", texthl = "DapStoppedColor", linehl = "DapStoppedLine"
      })
    end,
  },

  -- fancy UI for the debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
    },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
