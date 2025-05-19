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
    },
    keys = {
      { "<leader>ac", ":CodeCompanionChat<cr>",    desc = "Toggle CodeCompanion chat buffer" },
      { "<leader>ai", ":CodeCompanion<cr>",        desc = "Use the CodeCompanion Inline Assistant" },
      { "<leader>aa", ":CodeCompanionActions<cr>", desc = "Open the CodeCompanion actions palette" },
      { "<leader>ad", ":CodeCompanionCmd<cr>",     desc = "Prompt the LLM to write a command for the command-line" },
    },
    ---@type CodeCompanion
    opts = {
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = op_get_credentials("OpenAI")
              -- api_key = "cmd:op read op://Development/OpenAI/credential --no-newline",
            },
            schema = {
              model = {
                default = "o3",
              },
            },
          })
        end,
        -- Qwen3 32B dense and mixture-of-experts (MoE) models
        qwen3 = extend_ollama("qwen3", "qwen3:latest", 40960),
        -- Mistral Nemo 12B model with 128k context length, built by Mistral AI in collaboration with NVIDIA
        mistral_nemo = extend_ollama("mistral_nemo", "mistral-nemo:latest", 1024000),
        -- Gemma 3 27B lightweight family of models built on Gemini technology
        gemma3 = extend_ollama("gemma3", "gemma3:27b", 131072),
        -- QwQ reasoning model
        qwq = extend_ollama("qwq", "qwq:latest", 131072),
      },
      strategies = {
        chat = {
          -- adapter = "ollama",
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
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return "CodeCompanion (" .. adapter.formatted_name .. ")"
            end,
          },
        },
        inline = {
          -- adapter = "copilot",
        },
      },
      display = {
        action_palette = {
          provider = "default",                 -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true,        -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
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
      },
    },
  },
}
