-- Trash the target
local function trash(state)
  local cmds = require("neo-tree.sources.buffers.commands")

  local tree = state.tree
  local node = tree:get_node()
  if node.type == "message" then
    return
  end

  vim.api.nvim_command("silent !trash -F " .. node.path)
  cmds.refresh(state)
end

-- Trash the selections (visual mode)
local function trash_visual(state, selected_nodes)
  local cmds = require("neo-tree.sources.buffers.commands")

  for _, node in ipairs(selected_nodes) do
    if node.type ~= 'message' then
      vim.api.nvim_command("silent !trash -F " .. node.path)
    end
  end

  cmds.refresh(state)
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      {
        version = "2.*",
        "s1n7ax/nvim-window-picker",
        config = function()
          require "window-picker".setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    cmd = {
      "NeoTree",
    },
    event = "User DirOpened",
    keys = {
      { "<leader>ee", ":Neotree toggle focus<cr>",                  desc = "Explorer" },
      { "<leader>ec", ":Neotree close<cr>",                         desc = "Close all" },
      { "<leader>ef", ":Neotree focus reveal<cr>",                  desc = "Find current file" },
      { "<leader>eb", ":Neotree toggle focus buffers<cr>",          desc = "Buffers" },
      { "<leader>bL", ":Neotree toggle focus buffers<cr>",          desc = "List open Buffers" },
      { "<leader>eg", ":Neotree toggle focus git_status<cr>",       desc = "Git status" },
      { "<leader>es", ":Neotree toggle focus document_symbols<cr>", desc = "Symbols" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
      -- when opening files, do not use windows containing these filetypes or buftypes
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      -- used when sorting files and directories in the tree
      sort_case_insensitive = false,
      -- use a custom function for sorting files and directories in the tree
      sort_function = nil,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      default_component_configs = {
        container = {
          enable_character_fade = true
        },
        diagnostics = {
          symbols = {
            hint  = "󰌵",
            info  = "",
            warn  = "",
            error = "",
          },
          highlights = {
            hint = "DiagnosticSignHint",
            info = "DiagnosticSignInfo",
            warn = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = "*",
          highlight = "NeoTreeFileIcon"
        },
        modified = {
          symbol = "",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            renamed   = "",
            deleted   = "",
            untracked = "",
            ignored   = "",
            unstaged  = "",
            staged    = "",
            conflict  = "",
          }
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- see `:h neo-tree-custom-commands-global`
      commands = {
      },
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          -- disable `nowait` if you have existing combos starting with this char that you want to use
          ["<space>"] = { "toggle_node", nowait = false, },
          ["<2-LeftMouse>"] = "open_drop",
          ["<cr>"] = "open_drop",
          ["<esc>"] = "cancel", -- close preview or floating neo-tree window
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["l"] = "focus_preview",
          ["S"] = "split_with_window_picker",
          ["<C-x>"] = "open_split",
          ["s"] = "vsplit_with_window_picker",
          ["<C-v>"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["<C-t>"] = "open_tab_drop",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",
          ["a"] = {
            "add",
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = "relative" -- "none", "relative", "absolute"
            }
          },
          ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ["r"] = "rename",
          ["<S-F6>"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = { "copy", config = { show_path = "relative" }, },
          ["m"] = { "move", config = { show_path = "relative" }, },
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["i"] = "show_file_details",
        }
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          -- when true, they will just be displayed differently than normal items
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            ".git",
          },
          -- uses glob style patterns
          hide_by_pattern = {
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          -- remains visible even if other settings would normally hide it
          always_show = {
            ".gitignore",
          },
          -- remains hidden even if visible is toggled to true, this overrides always_show
          never_show = {
            ".DS_Store",
            "thumbs.db"
          },
          -- uses glob style patterns
          never_show_by_pattern = {
            --".null-ls_*",
          },
        },
        follow_current_file = {
          -- This will find and focus the file in the active buffer every time
          -- the current file is changed while the tree is open.
          enabled = false,
          -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          leave_dirs_open = false,
        },
        -- when true, empty folders will be grouped together
        group_empty_dirs = true,
        -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        hijack_netrw_behavior = "open_default",
        -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "open_current",
        -- netrw left alone, neo-tree does not handle opening dirs
        -- "disabled",
        -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        use_libuv_file_watcher = false,
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
            ["d"] = { "trash", nowait = false },
            ["f"] = "filter_on_submit",
            ["<c-l>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["og"] = { "order_by_git_status", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<down>"] = "move_cursor_down",
            ["<C-n>"] = "move_cursor_down",
            ["<up>"] = "move_cursor_up",
            ["<C-p>"] = "move_cursor_up",
          },
        },
        -- Add a custom command or override a global one using the same function name
        commands = {
          trash = trash,
          trash_visual = trash_visual,
        }
      },
      buffers = {
        follow_current_file = {
          -- This will find and focus the file in the active buffer every time
          -- the current file is changed while the tree is open.
          enabled = true,
          -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          leave_dirs_open = false,
        },
        -- when true, empty folders will be grouped together
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ["d"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          }
        },
      },
      git_status = {
        window = {
          position = "bottom",
          mappings = {
            ["A"]  = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
            ["o"]  = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          }
        }
      },
      document_symbols = {
        -- automatically focus on the symbol under the cursor
        follow_cursor = true,
        window = {
          position = "right",
          mappings = {
            ["o"] = "jump_to_symbol",
            ["r"] = "rename",
            ["P"] = "preview",
            ["A"] = "",
            ["a"] = "",
            ["c"] = "",
            ["d"] = "",
            ["i"] = "",
            ["m"] = "",
            ["p"] = "",
            ["x"] = "",
            ["y"] = "",
          },
        }
      },
    },
  },
}
