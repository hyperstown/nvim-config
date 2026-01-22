local presets = require("markview.presets").headings;

return {
  "OXY2DEV/markview.nvim",
  opts = {
    markdown = {
      headings = presets.arrowed
    },
    preview = {
      filetypes = {}, -- disable until I trigger it
    },
  },
}
