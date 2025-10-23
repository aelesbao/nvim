local function diff_source()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

return {
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "folke/tokyonight.nvim",
      "SmiteshP/nvim-navic",
      "AndreM222/copilot-lualine",
    },
    event = "VeryLazy",
    opts = function()
      local colors = require("tokyonight.colors").setup()

      return {
        options = {
          theme = "tokyonight",
          icons_enabled = true,
          globalstatus = true,
          -- component_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          disabled_filetypes = {
            winbar = {
              "help",
              "neo-tree",
              "NvimTree",
              "undotree",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "b:gitsigns_head", icon = "" },
            { "diff", source = diff_source },
            "diagnostics"
          },
          lualine_c = { "filename" },
          lualine_x = {
            {
              "copilot",
              symbols = {
                status = {
                  hl = {
                    enabled = colors.green,
                    disabled = colors.comment,
                    warning = colors.yellow,
                    unknown = colors.red,
                  },
                },
              },
              show_colors = true,
              show_loading = true,
            },
            {
              function()
                -- Check if MCPHub is loaded
                if not vim.g.loaded_mcphub then
                  return "󰐻 -"
                end

                local count = vim.g.mcphub_servers_count or 0
                local status = vim.g.mcphub_status or "stopped"
                local executing = vim.g.mcphub_executing

                -- Show "-" when stopped
                if status == "stopped" then
                  return "󰐻 -"
                end

                -- Show spinner when executing, starting, or restarting
                if executing or status == "starting" or status == "restarting" then
                  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                  local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                  return "󰐻 " .. frames[frame]
                end

                return "󰐻 " .. count
              end,
              color = function()
                if not vim.g.loaded_mcphub then
                  return { fg = colors.comment } -- Gray for not loaded
                end

                local status = vim.g.mcphub_status or "stopped"
                if status == "ready" or status == "restarted" then
                  return { fg = colors.green1 } -- Green for connected
                elseif status == "starting" or status == "restarting" then
                  return { fg = colors.orange } -- Orange for connecting
                else
                  return { fg = colors.red1 }   -- Red for error/stopped
                end
              end,
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        winbar = {
          lualine_c = {
            { "filename", path = 1, color = { bg = "NONE" } },
            {
              "navic",

              -- Component specific options
              -- Can be nil, "static" or "dynamic". This option is useful only when
              -- you have highlights enabled. Many colorschemes don't define same
              -- backgroud for nvim-navic as their lualine statusline backgroud.
              -- Setting it to "static" will perform a adjustment once when the
              -- component is being setup. This should be enough when the lualine
              -- section isn't changing colors based on the mode.
              -- Setting it to "dynamic" will keep updating the highlights according
              -- to the current modes colors for the current section.
              color_correction = nil,

              -- lua table with same format as setup's option. All options except
              -- "lsp" options take effect when set here.
              navic_opts = nil,
            },
          },
        },
        inactive_winbar = {
          lualine_c = {
            { "filename", path = 1, color = { bg = "NONE" } },
          },
        },
        extensions = {
          "avante",
          "fugitive",
          "lazy",
          "mason",
          "neo-tree",
          "quickfix",
          "trouble",
        },
      }
    end,
  },
}
