return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require("astroui.status")

    local original_virtual_env = status.provider.virtual_env
    status.provider.virtual_env = function(opts)
      opts = opts or {}
      opts.env_names = {} -- FORCE EMPTY

      return function ()
        local conda = vim.env.CONDA_DEFAULT_ENV
        local venv = vim.env.VIRTUAL_ENV
        local version_str = ""
        if venv or (opts.conda and opts.conda.enabled and conda) then
          python = require("venv-selector").python()
          local result = vim.system({ python, "--version" }, { text = true }):wait()
          if result.code == 0 and result.stdout ~= "" then
            version_str = vim.trim(result.stdout)
          end
        end
        local venv_type = (venv and "venv") or (opts.conda and opts.conda.enabled and conda and "conda") 
        local name = original_virtual_env(opts)()
        if not name then
          return name
        end
        if venv_type or version_str ~= "" then
          venv_type = " - " .. version_str .. (venv_type and "(" .. (venv_type or "") .. ")") 
        end
        return name .. (venv_type or "")
      end
    end

    local function file_info_provider(opts)
      opts = opts or {}
      local enc = vim.bo.fileencoding or vim.o.encoding
      local fmt = vim.bo.fileformat
      local sw = vim.bo.shiftwidth
      local et = vim.bo.expandtab and "Spaces" or "Tabs"

      local text = string.format("%s [%s] ", enc:upper(), fmt:upper())
      if sw > 0 then
        text = text .. string.format("%s: %d", et, sw)
      end
      return require("astroui.status.utils").stylize(text, opts)
    end

    local git_ahead_behind = {
      condition = function()
        return require("astroui.status.condition").is_git_repo()
      end,
      init = function(self)
        self.status = vim.g.git_changes or {"0", "0"}
        self.ahead = self.status[1]
        self.behind = self.status[2]
      end,
      provider = function(self)
        return string.format(" %d %d", self.behind, self.ahead)
      end,
      padding = { left = 1, right = 1 },
      hl = { fg = "fg" },
      on_click = {
        callback = function()
          vim.system({ "git", "pull", "--rebase" }, {}, function(res)
            if res.code ~= 0 then
              local msg = vim.trim(res.stderr ~= "" and res.stderr or res.stdout)
              vim.schedule(function()
                vim.notify(
                  "Git pull failed:\n" .. msg,
                  vim.log.levels.ERROR,
                  { title = "Git Sync" }
                )
              end)
              return
            end
            vim.system({ "git", "push" })
          end)
        end,
        name = "git_sync",
      }
    }

    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode({
        padding = { right = 1 },
        -- enable mode text with padding as well as an icon before it
        mode_text = {
          icon = { kind = "VimIcon", padding = { right = 1, left = 1 }, },
        },
        -- surround the component with a separators
        surround = {
          -- it's a left element, so use the left separator
          separator = "left",
        },
      }),

      status.component.file_info({
          -- enable the file_icon and disable the highlighting based on filetype
          filename = { fallback = "Empty" },
          -- disable some of the info
          filetype = false,
          file_read_only = false,
          -- add padding
          padding = { right = 1 },
          -- define the section separator
          surround = { separator = "left", condition = false },
        }),

      status.component.git_branch(),
      status.component.git_diff(),
      git_ahead_behind,
      status.component.diagnostics(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      -- status.component.file_info(),
      status.component.lsp(),
      status.component.virtual_env(),
      status.component.builder({
        { provider = require('live-server.statusline.astronvim').live_server_provider },
        padding = { right = 1, left = 1 }
      }),
      status.component.builder({
        { provider = file_info_provider },
        hl = { fg = "fg" },
        surround = { separator = "right" },
      }),
      status.component.treesitter(),
      status.component.nav(),
    }
  end,
}
