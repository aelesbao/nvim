local utils = require("utils")

local function buf_wipeout()
  -- list of all buffer numbers
  local buffers = {}
  ---@diagnostic disable-next-line: param-type-mismatch
  for buf = 1, vim.fn.bufnr("$") do
    table.insert(buffers, buf)
  end

  -- save the current tab page
  local currentTab = vim.fn.tabpagenr()

  -- go through all tab pages
  for tab = 1, vim.fn.tabpagenr("$") do
    vim.cmd.tabnext(tab)

    -- go through all windows
    for win = 1, vim.fn.winnr("$") do
      -- whatever buffer is in this window in this tab, remove it from the buffers list
      local thisbuf = vim.fn.winbufnr(win)
      for i, buf in ipairs(buffers) do
        if buf == thisbuf then
          table.remove(buffers, i)
          break
        end
      end
    end
  end

  -- do not wipeout unlisted buffers
  for i = #buffers, 1, -1 do
    local buf = buffers[i]
    if vim.fn.getbufvar(buf, "&buflisted") == 0 or not vim.api.nvim_buf_is_valid(buf) then
      table.remove(buffers, i)
    end
  end

  -- delete the remaining buffers
  for _, buf in ipairs(buffers) do
    Snacks.bufdelete({ buf = buf, wipe = true })
  end

  -- go back to the original tab page
  vim.cmd.tabnext(currentTab)
  vim.notify(#buffers .. " hidden buffers wiped out")
end

return {
  -- a collection of small QoL plugins for Neovim.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dim = { enabled = true, },
      explorer = {
        replace_netrw = true,
      },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = vim.fn.executable("lazygit") == 1 },
      notifier = {
        enabled = true,
        timeout = 5000, -- default timeout in ms
      },
      ---@type snacks.picker.Config
      picker = {
        jump = {
          reuse_win = true,
        },
        win = {
          input = {
            keys = {
              ["<c-x>"] = "edit_split",
            }
          },
          list = {
            keys = {
              ["<c-x>"] = "edit_split",
            }
          },
        }
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
      ---@class snacks.zen.Config
      zen = {
        enabled = true,
        -- You can add any `Snacks.toggle` id here.
        -- Toggle state is restored when the window is closed.
        -- Toggle config options are NOT merged.
        ---@type table<string, boolean>
        toggles = {
          git_signs = true,
          diagnostics = true,
          inlay_hints = true,
        },
        --- Options for the `Snacks.zen.zoom()`
        ---@type snacks.zen.Config
        zoom = {
          toggles = {},
          show = {
            statusline = true,
            tabline = true
          },
          win = {
            backdrop = false,
            width = 0, -- full width
          },
        },
      }
    },
    keys = {
      -- Top Pickers & Explorer
      {
        "<leader><space>",
        function()
          Snacks.picker.smart({
            multi = {
              "buffers",
              { finder = "files",     hidden = true,    ignored = false },
              { finder = "git_files", untracked = true, submodules = true },
            },
            matcher = {
              frecency = true,      -- frecency bonus
              history_bonus = true, -- give more weight to chronological order
            }
          })
        end,
        desc = "Smart Find Files"
      },

      -- find
      { "<leader>,",  function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files" },
      { "<leader>fa", function() Snacks.picker.files({ hidden = true, ignored = true }) end,  desc = "Find All Files" },
      { "<leader>fg", function() Snacks.picker.git_files({ submodules = true }) end,          desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent" },
      { "<leader>E",  function() Snacks.explorer() end,                                       desc = "File Explorer" },

      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      { "<leader>gB", function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end,                                        desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end,                                    desc = "Git Log (Lazygit)" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,                               desc = "Git File Log (Lazygit)" },

      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>/",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },

      -- search
      { '<leader>s"', function() Snacks.picker.registers() end,                               desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end,                          desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>:",  function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end,                                    desc = "Undo History" },

      -- LSP
      { "gd",         function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gsd",        function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gsD",        function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
      { "gsr",        function() Snacks.picker.lsp_references() end,                          desc = "References",               nowait = true },
      { "gsi",        function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
      { "gst",        function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto Type Definition" },
      { "gsc",        function() Snacks.picker.lsp_incoming_calls() end,                      desc = "Incoming Calls" },
      { "gsC",        function() Snacks.picker.lsp_outgoing_calls() end,                      desc = "Outgoing Calls" },
      { "<leader>ss", function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },

      -- Other
      { "<leader>n",  function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      { "<leader>z",  function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",  function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<leader>.",  function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<leader>bw", buf_wipeout,                                                            desc = "Wipeout Hidden Buffers" },
      { "<leader>bO", function() Snacks.bufdelete.other() end,                                desc = "Delete Other Buffers" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<leader>un", function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
      { "<c-/>",      function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },

      -- news
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },

    init = function()
      utils.create_autocmd("User", {
        pattern = "VeryLazy",
        grpup = utils.augroup("snacks_setup"),
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
          }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
