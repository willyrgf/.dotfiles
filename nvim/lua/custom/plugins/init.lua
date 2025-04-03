return {
  --- style
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    enabled = true,
    priority = 100,
    config = function()
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },

  --- overrides
  -- treesitter
  {
    'nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'gdscript',
        'godot_resource',
        'gdshader',
      })

      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          node_decremental = '<BS>',
          scope_incremental = '<TAB>',
        },
      }

      return opts
    end,
  },

  --- utilities
  -- terminal as an popup window ctrl+t
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = 20,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      highlights = {
        FloatBorder = {
          guifg = '#3c3836', -- https://github.com/sainnhe/gruvbox-material/blob/3fff63b0d6a425ad1076a260cd4f6da61d1632b1/autoload/gruvbox_material.vim#LL44C37-L44C44
          --guifg = "#282828",
        },
      },
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
        },
      },
    },
  },

  --- AI assistant
  {
    'Exafunction/codeium.vim',
    enabled = true,
    event = 'VeryLazy',
    config = function()
      -- By default, disable it
      vim.g.codeium_enabled = false

      -- Add keybinding to toggle
      vim.keymap.set('n', '<leader>ce', function()
        if vim.g.codeium_enabled then
          vim.cmd 'CodeiumDisable'
        else
          vim.cmd 'CodeiumEnable'
        end
        vim.notify('Codeium toggled to: ' .. (vim.g.codeium_enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
      end, { desc = 'Toggle [C]odeium [E]nable/Disable' })

      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<C-g>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function()
        return vim.fn['codeium#Clear']()
      end, { expr = true, silent = true })

      -- Listen for Codeium enable/disable events
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'CodeiumEnable', 'CodeiumDisable' },
        callback = function(ev)
          if ev.match == 'CodeiumEnable' then
            vim.g.codeium_enabled = true
          else
            vim.g.codeium_enabled = false
          end
        end,
      })
    end,
  },
}
