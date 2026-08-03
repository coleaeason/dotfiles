-- Custom LSP configurations.
-- Servers are automatically installed with mason and loaded with lspconfig.
return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "sqlfluff" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "sql" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        sqlfluff = {
          prepend_args = {
            "format",
            "-",
          },
        },
      },
      formatters_by_ft = {
        sql = "sqlfluff",
      },
    },
  },
}
