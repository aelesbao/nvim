return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      },
      diagnostics = {
        disable = {
          "missing-fields",
        },
      },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
}
