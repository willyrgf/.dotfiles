local M = {}

-- FIXME: move this to an appropriated place
-- https://simondalvai.org/blog/godot-neovim/ # last update: 24. March 2025
function M.custom_gdscript()
  -- paths to check for project.godot file
  local paths_to_check = { '/', '/../' }
  local is_godot_project = false
  local godot_project_path = ''
  local cwd = vim.fn.getcwd()

  -- iterate over paths and check
  for _, value in pairs(paths_to_check) do
    local project_file = cwd .. value .. 'project.godot'
    local ok, result = pcall(vim.uv.fs_stat, project_file)

    if ok and result then
      is_godot_project = true
      godot_project_path = vim.fn.fnamemodify(cwd .. value, ':p') -- Get absolute path
      break
    end
  end

  if is_godot_project then
    -- check if server is already running in godot project path
    local server_pipe = godot_project_path .. 'server.pipe'
    local ok, result = pcall(vim.uv.fs_stat, server_pipe)
    local is_server_running = ok and result

    -- start server, if not already running
    if not is_server_running then
      local ok, err = pcall(vim.fn.serverstart, server_pipe)
      if not ok then
        vim.notify('Failed to start server: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end

  -- godot lsp
  if is_godot_project then
    -- setup lsp
    require('lspconfig')['gdscript'].setup {}
  end
end

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
end

--- options set up
function M.setup()
  M.vim_opts()
  M.keymaps()
end

M.setup()
M.custom_gdscript()

return M
