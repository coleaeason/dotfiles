-- Custom LSP configurations.
-- Servers are automatically installed with mason and loaded with lspconfig.
return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tailwind = {},
      },
    },
  },
}
