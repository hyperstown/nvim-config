return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local cspell = require "cspell"

    local cspell_config = {
      config_file_preferred_name = "cspell.json",  -- Name for new configs created by code actions
      cspell_config_dirs = {
        vim.fn.stdpath("config"),  -- Global dir (e.g., ~/.config/nvim)
        vim.loop.cwd(),            -- Project dir (current working directory)
        vim.loop.cwd() .. "/.vscode",            -- Another popular dir
        vim.loop.cwd() .. "/.config",            -- Another popular dir
        vim.loop.cwd() .. "/.nvim",            -- Another popular dir
      }
    }

    opts.debounce = 500

    opts.sources = vim.list_extend(opts.sources or {}, {
      cspell.diagnostics.with({
        config = cspell_config,
        diagnostics_postprocess = function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity.HINT
        end
      }),
      cspell.code_actions.with({ config = cspell_config }),
    })
  end,
}
