return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    cmd = "MCPHub",
    -- build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    opts = {
      use_bundled_binary = true, -- Set to true if you want to use the bundled mcp-hub binary
      -- If set to false, the plugin will use the globally installed mcp-hub binary
      -- This is useful if you don't have npm or can't install packages globally
      -- or if you want to use a specific version of mcp-hub
      -- (e.g. if you have a different version installed globally)

      -- Custom Server command configuration
      cmd = "nvm exec default node", -- The command to invoke the MCP Hub Server
    },
  },
}
