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
        config = function(_, opts)
            vim.lsp.conf.setup({ server = opts })
            return true
        end,
		opts = {
            -- inlay_hints = {
            --     enabled = true,
            -- },
        servers = { 
            rust_analyzer = { }
        }
    }
}
        --         imports = {
        --             granularity = {
        --                 group = "module",
        --             },
        --         prefix = "self",
        --         },
        --         cargo = {
        --             buildScripts = {
        --                 enable = true,
        --             },
        --         },
        --         procMacro = {
        --             enable = true
        --         },
        --     },
        -- },
    --     },
    -- },
}
