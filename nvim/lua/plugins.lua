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
		config = function(server, opts)
            for server, settings in pair(opts.servers) do
                vim.lsp.config(server, settings)
                vim.lsp.enable(server)
            end
        end,
		opts = function()
            local servers = { 
                rust_analyzer = { settings = {
            --     imports = {
            --         granularity = {
            --             group = "module",
            --         },
            --     prefix = "self",
            --     },
            --     cargo = {
            --         buildScripts = {
            --             enable = true,
            --         },
            --     },
            --     procMacro = {
            --         enable = true
            --     },
            -- },
        },
            -- inlay_hints = {
            --    enabled = true,
            --},
        },
        },
            return servers
        end,
    },
}
