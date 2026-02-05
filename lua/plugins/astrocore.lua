-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Patch close tab as it throws an error when closing CodeDiff tab
local buff_module = require("astrocore.buffer")
local original_close_tab = buff_module.close_tab
buff_module.close_tab = function(tabpage) pcall(original_close_tab, tabpage) end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- All of autocommands grouped
    autocmds = {
      neotree_on_session_load = {
        {
          event = "User",
          pattern = "ResessionLoadPost",
          desc = "Open Neo-tree after restoring a session",
          callback = function()
            vim.notify("Restored!")
            vim.schedule(function() vim.cmd("Neotree filesystem reveal left") end)
          end,
        },
      },
      automatic_insert_on_buffer_enter = {
        {
          event = "WinEnter",
          desc = "Automatically enter insert mode when entering window",
          callback = function()
            if vim.bo.buftype == "terminal" then
              vim.cmd("startinsert")
              return
            end
            vim.b.autoformat = false
            if vim.b._was_insert then
              vim.cmd("startinsert")
            else
              vim.cmd("stopinsert")
            end
          end,
        },
        {
          event = "WinLeave",
          desc = "Store last mode in buf",
          callback = function()
            if vim.bo.buftype == "terminal" then
              -- terminals don't need remembering
              return
            end
            vim.b._was_insert = vim.fn.mode():match("^i")
          end,
        },
      },
      venv_selector = {
        {
          event = "BufNew",
          pattern = "*.py",
          -- If I don't do this new buffer don't find venvs? Idk why this happens..
          desc = "Restart LSP to detect venv for every buffer",
          callback = function(event)
            vim.schedule(function() vim.cmd("LspRestart") end)
          end,
        },
      },
    },
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.numbr
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        neominimap = {
          click = {
            enabled = true,
          },
          diagnostic = {
            mode = "icon", -- icon|sign
          },
        },
        copilot_filetypes = {
          env = false,
          sh = false,
          json = false,
        },
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      v = {
        ["<Leader>t"] = { "<cmd>TextCaseOpenTelescope<CR>", desc = "Text transform" },
        ["<Leader>f"] = {
          function()
            require("grug-far").open({ prefills = { paths = vim.fn.expand("%:."), search = vim.fn.expand("<cword>") } })
          end,
          desc = "Find in current file",
        },
      },
      i = {
        ["<A-Down>"] = { "<cmd>m .+1<cr>", desc = "Move line down" },
        ["<A-Up>"] = { "<cmd>m .-2<cr>", desc = "Move line up" },
        ["<C-s>"] = { "<cmd>w<cr>", desc = "Save" },
      },
      t = {
        ["jkk"] = { "<C-\\><C-n>", desc = "Better esc in terminal" },
        ["<Leader><Esc>"] = { "<C-\\><C-n>", desc = "Better esc in terminal" },
      },
      n = {
        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<A-Down>"] = { "<cmd>m .+1<cr>", desc = "Move line down" },
        ["<A-Up>"] = { "<cmd>m .-2<cr>", desc = "Move line up" },
        ["<A-j>"] = { "<cmd>m .+1<cr>", desc = "Move line down" },
        ["<A-k>"] = { "<cmd>m .-2<cr>", desc = "Move line up" },
        ["<C-a>"] = { "ggVG", desc = "Select all" },
        ["<C-s>"] = { "<cmd>w<cr>", desc = "Save" },
        ["<Leader>gD"] = {
          function()
            vim.cmd("CodeDiff")
            vim.defer_fn(function() vim.cmd("Neominimap TabDisable") end, 500)
          end,
          desc = "View Code Git diff",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>t"] = { desc = " Terminal" },
        ["<Leader>z"] = { desc = " Colors" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
