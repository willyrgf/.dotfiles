vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
-- fast moving
vim.opt.updatetime = 50
vim.o.timeoutlen = 100

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

