local M = {}

function M.vim_opts()
  --- general
  vim.opt.relativenumber = true
  vim.opt.guicursor = ''
  vim.opt.relativenumber = true
  vim.opt.scrolloff = 8
  vim.opt.signcolumn = 'yes'
  vim.opt.isfname:append '@-@'

  -- fast moving
  vim.opt.updatetime = 50
end

function M.keymaps()
  -- preserve paste buffer
  vim.keymap.set('x', '<leader>p', '"_dP')
  vim.keymap.set('n', '<leader>y', '"+y')
  vim.keymap.set('v', '<leader>y', '"+y')
  vim.keymap.set('n', '<leader>Y', '"+Y')

  -- removing shit keymaps
  vim.keymap.set('n', 'Q', '<nop>')
  vim.keymap.set('n', 's', '<nop>') -- enables mini.surround

  -- quickfix list navigation
  vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
  vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
  vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
  vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

  vim.keymap.set('n', '<leader>sF', function()
    require('telescope.builtin').find_files({
      hidden = true,
      no_ignore = true,
      follow = true,
    })
  end, { desc = '[S]earch [F]iles (all)' })

  vim.keymap.set('n', '<leader>sG', function()
    require('telescope.builtin').live_grep({
      additional_args = function()
        return { '--hidden', '--no-ignore', '--glob', '!**/.git/*' }
      end,
    })
  end, { desc = '[S]earch by [G]rep (all)' })
end

--- options set up
function M.setup()
  M.vim_opts()
  M.keymaps()
end

M.setup()

return M
