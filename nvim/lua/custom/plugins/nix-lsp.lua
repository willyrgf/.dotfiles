-- Nix LSP via nil, installed externally via Nix (not Mason)
return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			vim.lsp.config("nil_ls", {
				settings = {
					["nil"] = {
						nix = {
							flake = {
								autoArchive = false,
								autoEvalInputs = false,
								nixpkgsInputName = "",
							},
						},
					},
				},
			})
			vim.lsp.enable("nil_ls")
		end,
	},
}
