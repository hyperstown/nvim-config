-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "olimorris/onedarkpro.nvim",
    opts = {
      options = {
        highlight_inactive_windows = false,
      },
    },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      -- colorscheme = "tokyodark",
      -- colorscheme = "catppuccin",
      colorscheme = "onedark_vivid",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      status = {
        -- Optional: Add attributes like bold/italic (applies to the groups)
        attributes = {
          buffer_active = { bold = true, italic = false }, -- Make active tab bold
        },
      },
      highlights = {
        init = function()
          local NormalF = require("astroui").get_hlgroup("NormalFloat")
          local Normal = require("astroui").get_hlgroup("Normal")
          return {
            -- Better colors for files
            StatusLine = { bg = Normal.bg },
            TabLineFill = { bg = NormalF.bg },
            NeoTreeGitUntracked = { fg = "#98c379" },
            NeoTreeNormalNC = { bg = NormalF.bg },
            NeoTreeNormal = { bg = NormalF.bg },
            NeoTreeWinSeparator = { bg = NormalF.bg, fg = NormalF.bg },
            NeoTreeDotfile = { fg = "#5c6370" },
          }
        end,
      },
      -- Icons can be configured throughout the interface
      icons = {
        -- configure the loading of the lsp in the status line
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
        VimIcon = "",
        ScrollText = "",
        GitBranch = "",
        GitAdd = "",
        GitChange = "",
        GitDelete = "",
      },
    },
  },
}
