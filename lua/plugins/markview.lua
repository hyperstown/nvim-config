local presets = require("markview.presets").headings;

return {
  "OXY2DEV/markview.nvim",
  keys = {
    {"<leader>lm", "<cmd>Markview splitToggle<CR>", mode = "n", desc = "Toggle Markdown Preview" },
  },
  opts = {
    markdown = {
      headings = presets.arrowed
    },
    preview = {
      filetypes = {}, -- disable until I trigger it
    },
  },
}
