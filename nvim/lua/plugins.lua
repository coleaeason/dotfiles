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
		-- keys = {
		--     { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
		-- },
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
								enable = true,
							},
							check = {
								command = "clippy",
							},
						},
					},
					on_attach = function(client, bufnr)
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end,
				},
				ty = {
					settings = {
						ty = {
							configuration = {
								rules = {
									["unresolved-import"] = "ignore",
								},
							},
						},
					},
					on_attach = function(client, bufnr)
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end,
				},
				ruff = {
					settings = {},
				},
			}

			-- Load all of the servers in the above servers array
			for server, opts in pairs(servers) do
				-- opts.on_attach = function(client, bufnr)
				--     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				-- end,

				vim.lsp.config[server] = opts
				vim.lsp.enable(server)
			end
			vim.diagnostic.config({ virtual_lines = true })
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
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = {
				preset = {
					pick = function(cmd, opts)
						return LazyVim.pick(cmd, opts)()
					end,
					header = [[
          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
   ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
				},
			},
		},
	},
}
