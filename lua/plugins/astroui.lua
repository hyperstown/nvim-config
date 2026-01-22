-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    -- colorscheme = "tokyodark",
    -- colorscheme = "catppuccin",
    colorscheme = "onedark",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    status = {
      colors = {
        tabline_bg = "#1b1f27",
        buffer_bg = "#1b1f27",
        -- buffer_fg = "#a0a0a0",   
        -- buffer_active_fg = "#ffffff",
        -- buffer_active_bg = "#525368", 
      },
      -- Optional: Add attributes like bold/italic (applies to the groups)
      attributes = {
        buffer_active = { bold = true, italic = false },  -- Make active tab bold
      },
    },
    highlights = {
      init = function()
        local get_hlgroup = require("astroui").get_hlgroup
        -- get highlights from highlight groups
        local Normal = get_hlgroup("Normal")

        return {
          -- Better colors for files
          NeoTreeGitUntracked = { fg = "#98c379" },
          NeoTreeTabInactive = { fg = "#c0caf5", bg = "#1f1f27" },
          NeoTreeTabSeparatorInactive = { fg = "#1f1f27", bg = "#1f1f27" },
          NeoTreeTabSeparatorActive = { fg = "#1f1f27" },
          NeoTreeNormalNC = { bg = "#1b1f27" },
          NeoTreeNormal = { bg = "#1b1f27" },
          NeoTreeDotfile = { fg = "#5c6370" },
          LineNrNC = { fg = "#495162", bg = "#282c34" },
          SignColumnNC = { bg = "#282c34" },
          NormalNC = { fg = Normal.fg, bg = Normal.bg },
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
}
