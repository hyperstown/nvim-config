-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  { import = "astrocommunity.colorscheme.tokyodark-nvim" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.split-and-window.neominimap-nvim" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  --{ import = "astrocommunity.scrolling.nvim-scrollbar" }, -- looks meh
  { import = "astrocommunity.scrolling.satellite-nvim" }, -- sometimes throws errors :p
  { import = "astrocommunity.git.codediff-nvim" },
  { import = "astrocommunity.search.grug-far-nvim" },
  { import = "astrocommunity.editing-support.text-case-nvim" },
  { import = "astrocommunity.editing-support.multiple-cursors-nvim" },
  { import = "astrocommunity.color.ccc-nvim" },
  { import = "astrocommunity.completion.copilot-vim" },

  -- import/override with your plugins folder
}
