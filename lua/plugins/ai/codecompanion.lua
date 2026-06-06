local utils = require("utils")

local Spinner = {}

function Spinner:init()
  local group = utils.augroup("codecompanion.spinner")

  utils.create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local handle = Spinner:create_progress_handle(request)
      Spinner:store_progress_handle(request.data.id, handle)
    end,
  })

  utils.create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle = Spinner:pop_progress_handle(request.data.id)
      if handle then
        Spinner:report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })
end

Spinner.handles = {}

function Spinner:store_progress_handle(id, handle)
  Spinner.handles[id] = handle
end

function Spinner:pop_progress_handle(id)
  local handle = Spinner.handles[id]
  Spinner.handles[id] = nil
  return handle
end

function Spinner:create_progress_handle(request)
  local progress = require("fidget.progress")
  return progress.handle.create({
    title = "CodeCompanion",
    message = "  Sending...",
    lsp_client = {
      name = Spinner:format(request.data.adapter),
    },
  })
end

---@param adapter CodeCompanion.HTTPAdapter
function Spinner:format(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

function Spinner:report_exit_status(handle, request)
  if request.data.status == "success" then
    handle.message = "Completed"
  elseif request.data.status == "error" then
    handle.message = " Error"
  else
    handle.message = "󰜺 Cancelled"
  end
end

local function op_get_credentials(provider)
  local item_name = "op://development/" .. provider .. "/credential"
  local stdout, stderr = require("op.api").read({ item_name, "--no-newline" })
  if not stdout or #stdout == 0 then
    vim.notify(
      "Error reading " .. provider .. " credential: " .. table.concat(stderr, "\n"),
      vim.log.levels.ERROR,
      { title = "CodeCompanion" }
    )
  end

  return stdout[1]
end

return {
  -- AI-powered coding, seamlessly in Neovim
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "j-hui/fidget.nvim", -- Display status
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
      -- which key integration
      "folke/which-key.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionHistory",
    },
    keys = {
      { "<leader>ai", ":CodeCompanion<cr>",        desc = "Use the CodeCompanion Inline Assistant",                 mode = { "n", "v" }, },
      { "<leader>aa", ":CodeCompanionActions<cr>", desc = "Open the CodeCompanion actions palette",                 mode = { "n", "v" }, },
      { "<leader>aC", ":CodeCompanionChat<cr>",    desc = "Toggle CodeCompanion chat buffer",                       mode = { "n", "v" }, },
      { "<leader>ad", ":CodeCompanionCmd<cr>",     desc = "Prompt the LLM to write a command for the command-line", mode = { "n", "v" }, },
      { "<leader>ah", ":CodeCompanionHistory<cr>", desc = "Opens CodeCompanion history browser",                    mode = { "n", "v" }, },
    },
    ---@module "codecompanion"
    ---@type CodeCompanion
    opts = {
      adapters = {
        http = {
          openai  = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = op_get_credentials("OpenAI")
                -- api_key = "cmd:op read op://Development/OpenAI/credential --no-newline",
              },
              schema = {
                model = {
                  default = "gpt-5.4",
                },
              },
            })
          end,
          gpt_oss = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "gpt-oss",
              schema = {
                model = {
                  default = "gpt-oss:latest",
                },
                num_ctx = {
                  default = 128000,
                },
                think = {
                  default = true,
                },
                temperature = {
                  default = 0.3,
                },
              },
            })
          end,
          gemma4  = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "gemma4",
              schema = {
                model = {
                  default = "gemma4:31b",
                },
                num_ctx = {
                  default = 256000,
                },
                temperature = {
                  default = 0.3,
                },
              },
            })
          end,
          qwen3_6 = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwen3.6",
              schema = {
                model = {
                  default = "qwen3.6:27b"
                },
                num_ctx = {
                  default = 256000,
                },
                temperature = {
                  default = 0.3,
                },
              },
            })
          end
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                ANTHROPIC_API_KEY = op_get_credentials("Anthropic"),
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "opencode",
          keymaps = {
            send = {
              modes = {
                n = { "<CR>", "<C-s>", "<M-CR>" },
                i = { "<C-s>", "<M-CR>" }
              },
            },
            close = {
              modes = {
                n = { "<C-c>", "q" },
                i = "<C-c>"
              },
            },
            completion = {
              modes = {
                i = { "<C-Space>", "<C-x>" },
              },
            },
          },
          slash_commands = {
            ["buffer"] = {
              keymaps = {
                modes = {
                  i = "<C-b>",
                },
              },
            },
            ["fetch"] = {
              keymaps = {
                modes = {
                  i = "<C-f>",
                },
              },
            },
            ["help"] = {
              opts = {
                max_lines = 1000,
              },
            },
            ["image"] = {
              keymaps = {
                modes = {
                  i = "<C-i>",
                },
              },
              opts = {
                dirs = { "~/Pictures/Screenshots" },
              },
            },
            -- ["git_files"] = {
            --   description = "List git files",
            --   ---@param chat CodeCompanion.Chat
            --   callback = function(chat)
            --     local handle = io.popen("git ls-files")
            --     if handle ~= nil then
            --       local result = handle:read("*a")
            --       handle:close()
            --       chat:add_reference({ role = "user", content = result }, "git", "<git_files>")
            --     else
            --       return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
            --     end
            --   end,
            --   opts = {
            --     contains_code = false,
            --   },
            -- },
          },
          roles = {
            user = "aelesbao",
            ---The header name for the LLM's messages
            ---@type string|fun(adapter: CodeCompanion.HTTPAdapter): string
            llm = function(adapter)
              return "CodeCompanion (" .. adapter.formatted_name .. ")"
            end,
          },
        },
        inline = {
          adapter = "copilot",
        },
        cli = {
          agent = "opencode",
          agents = {
            opencode = {
              cmd = "opencode",
              args = {},
              description = "OpenCode",
              provider = "terminal",
            },
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code",
              provider = "terminal",
            },
          },
        },
        background = {
          chat = {
          },
        },
      },
      display = {
        action_palette = {
          provider = "snacks",                  -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true,        -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            title = "CodeCompanion actions",    -- The title of the action palette
          },
        },
        chat = {
          -- show_references = true,
          -- show_header_separator = false,
          -- show_settings = false,
          icons = {
            tool_success = "󰸞 ",
          },
          fold_context = true,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true,           -- Show tool results directly in chat buffer
            format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            -- TODO: revert to `true` when this issue is fixed https://github.com/ravitemer/mcphub.nvim/issues/275
            make_vars = false,          -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
            picker = "snacks",
            -- Automatically generate titles for new chats
            auto_generate_title = true,
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,
          }
        },
      },
      opts = {
        log_level = "INFO", -- TRACE|DEBUG|ERROR|INFO
        wait_timeout = 2e6, -- Time to wait for user response before timing out (milliseconds)
      },
    },
    init = function()
      Spinner:init()
    end,
    config = function(_, opts)
      require("codecompanion").setup(opts)
      require("which-key").add({
        mode = { "n", "v" },
        { "<leader>a", group = "ai" },
      })
    end,
  },
}
