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

local function extend_ollama(adapter, model, context)
  return function()
    return require("codecompanion.adapters").extend("ollama", {
      name = adapter,
      schema = {
        model = {
          default = model,
        },
        num_ctx = {
          default = context,
        },
      },
    })
  end
end

return {
  -- AI-powered coding, seamlessly in Neovim
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionHistory",
    },
    keys = {
      { "<leader>ai", ":CodeCompanion<cr>",        desc = "Use the CodeCompanion Inline Assistant" },
      { "<leader>aa", ":CodeCompanionActions<cr>", desc = "Open the CodeCompanion actions palette" },
      { "<leader>ac", ":CodeCompanionChat<cr>",    desc = "Toggle CodeCompanion chat buffer" },
      { "<leader>ad", ":CodeCompanionCmd<cr>",     desc = "Prompt the LLM to write a command for the command-line" },
      { "<leader>ah", ":CodeCompanionHistory<cr>", desc = "Opens CodeCompanion history browser" },
    },
    ---@type CodeCompanion
    opts = {
      adapters = {
        http = {
          openai       = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = op_get_credentials("OpenAI")
                -- api_key = "cmd:op read op://Development/OpenAI/credential --no-newline",
              },
              schema = {
                model = {
                  default = "gpt-5",
                },
              },
            })
          end,
          -- Qwen3 32B dense and mixture-of-experts (MoE) models
          qwen3        = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwen3",
              schema = {
                model = {
                  default = "qwen3:latest",
                },
                num_ctx = {
                  default = 40960,
                },
                think = {
                  default = false,
                },
                temperature = {
                  default = 0.3,
                },
              },
            })
          end,
          -- Alibaba's performant long context models for agentic and coding tasks
          qwen3_coder  = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwen3-coder",
              schema = {
                model = {
                  default = "qwen3-coder:latest",
                },
                num_ctx = {
                  default = 262144,
                },
                think = {
                  default = false,
                },
              },
            })
          end,
          -- QwQ is the reasoning model of the Qwen series
          qwq          = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwq",
              schema = {
                model = {
                  default = "qwq:latest",
                },
                num_ctx = {
                  default = 131072,
                },
                think = {
                  default = true,
                },
              },
            })
          end,
          -- Gemma 3 27B lightweight family of models built on Gemini technology
          gemma3       = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "gemma3",
              schema = {
                model = {
                  default = "gemma3:27b",
                },
                num_ctx = {
                  default = 131072,
                },
              },
            })
          end,
          -- Mistral Nemo 12B model with 128k context length, built by Mistral AI in collaboration with NVIDIA
          mistral_nemo = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "mistral_nemo",
              schema = {
                model = {
                  default = "mistral-nemo:latest",
                },
                num_ctx = {
                  default = 1024000,
                },
              },
            })
          end,
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
      strategies = {
        chat = {
          adapter = "ollama",
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
          },
          slash_commands = {
            ["git_files"] = {
              description = "List git files",
              ---@param chat CodeCompanion.Chat
              callback = function(chat)
                local handle = io.popen("git ls-files")
                if handle ~= nil then
                  local result = handle:read("*a")
                  handle:close()
                  chat:add_reference({ role = "user", content = result }, "git", "<git_files>")
                else
                  return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
                end
              end,
              opts = {
                contains_code = false,
              },
            },
          },
          roles = {
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
      },
      display = {
        action_palette = {
          provider = "default",                 -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true,        -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            title = "CodeCompanion actions",    -- The title of the action palette
          },
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,           -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
            show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
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
            picker = "telescope",
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
    },
  },
}
