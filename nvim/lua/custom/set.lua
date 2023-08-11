---
--- general
vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- fast moving
vim.opt.updatetime = 50
vim.o.timeoutlen = 100

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]


---
--- plugins

-- rnix-lsp
-- https://github.com/neovim/nvim-lspconfig/blob/a981d4447b92c54a4d464eb1a76b799bc3f9a771/doc/server_configurations.md?plain=1#L7625
require 'lspconfig'.rnix.setup {}
