return {
    -- Plugins to load with lazy.nvim
    { 
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000, 
        lazy = false,     
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme catppuccin-mocha]])
        end, 
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local servers = {
                rust_analyzer = {
                    settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true
                        },
                        check = {
                            command = "clippy"
                        },
                    },
                },
                    on_attach = function(client, bufnr)
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
            }
        }

            -- Load all of the servers in the above servers array
            for server, opts in pairs(servers) do
                -- opts.on_attach = function(client, bufnr)
                --     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                -- end,
    
                vim.lsp.config[server] = opts
                vim.lsp.enable(server)
            end
        end,
    },
    {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
}
