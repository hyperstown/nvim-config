local config = {
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true, -- default
          typeCheckingMode = "standard",
          plugins = { "django-stubs", "djangorestframework-stubs" },
          reportMissingTypeStubs = true,
          diagnosticMode = "openFilesOnly", -- default
          useLibraryCodeForTypes = true, -- default
          diagnosticSeverityOverrides = {
            reportIncompatibleMethodOverride = false,
            reportIncompatibleVariableOverride = false,
            reportPrivateImportUsage = false,
            reportAttributeAccessIssue = false,
            reportArgumentType = false,
            reportAssignmentType = false,
            reportIndexIssue = false,
          },
        },
      },
    },
  },
}

vim.lsp.config("basedpyright", config.basedpyright)

return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- customize language server configuration options passed to `lspconfig`
      config = config,
      on_attach = function(client, bufnr)
        if client.name == "basedpyright" then
          local clients = vim.lsp.get_clients {
            name = "basedpyright",
            bufnr = bufnr,
          }
          if #clients > 1 then
            vim.schedule(function()
              client.stop()
            end)
          end
        end
      end,
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
    },
    ft = "python", -- Load when opening Python files
    keys = {
      { "<Leader>lv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" }, -- Open picker on keymap
    },
    opts = {
      search = {},
      options = {
        on_venv_activate_callback = function()
          local function run_shell_command()
            local selector = require "venv-selector"
            local venv_path = selector.venv()

            if venv_path and vim.uv.fs_stat(venv_path) then
              local activate = venv_path .. "/bin/activate"
              if vim.uv.fs_stat(activate) then vim.fn.chansend(vim.b.terminal_job_id, "source " .. activate .. "\n") end
            end
          end

          vim.api.nvim_create_augroup("TerminalCommands", { clear = true })

          vim.api.nvim_create_autocmd("TermOpen", {
            group = "TerminalCommands",
            pattern = "*",
            callback = run_shell_command,
          })
        end,
      },
    },
  },
}
