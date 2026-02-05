return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
  },
  keys = {
    { 
      "<Leader>gB", 
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].filetype == "gitsigns-blame" then
            vim.api.nvim_buf_delete(buf, {})
            return
          end
        end
        require("gitsigns").blame()
      end,
      mode = "n", 
      desc = "Whole file blame" 
    },
  },
  
}

