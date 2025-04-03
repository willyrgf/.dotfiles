-- Python LSP Configuration
return {
  -- Configure the LSP servers
  {
    'neovim/nvim-lspconfig',
    -- This will run after the core setup
    opts = function(_, opts)
      -- Extend the servers table in lspconfig setup
      local servers = opts.servers or {}
      servers.pyright = {
        settings = {
          pyright = {
            -- Let Ruff handle import organization
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      }

      servers.ruff = {
        settings = {
          ruff = {
            lint = {
              -- Enable Ruff's linting rules
              enable = true,
            },
            format = {
              -- Enable Ruff as a formatter
              enable = true,
            },
            organizeImports = true,
          },
        },
        -- Prevent Ruff and Pyright from fighting over the same diagnostics
        on_attach = function(client, _)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end,
      }

      opts.servers = servers
      return opts
    end,
  },

  {
    'mason-tool-installer.nvim',
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "pyright")
      table.insert(opts.ensure_installed, "ruff")
      return opts
    end,
  },
}
