return {
	{
		'oxalica/nil',
		lazy = true,
		enabled = vim.fn.executable('nil') == 1,
		config = function()
			local nvim_lsp = require('lspconfig')
			nvim_lsp["nil"].setup {
				cmd = { "nil" },
				filetypes = { "nix" },
			}
		end,
		-- opts = {
		-- 	cmd = { "nil" },
		-- 	filetypes = { "nix" },
		-- },
	}
}
