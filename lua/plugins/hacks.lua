return {
  "hyperstown/hacks.nvim",
  lazy = false,
  build = function(plugin)
    vim.notify("[hacks.nvim] Installing inline-js-ls dependencies…")

    local result = vim.system(
      { "npm", "install", "--silent" },
      { cwd = plugin.dir .. "/lua/hacks/inline_js_ls/js" }
    ):wait()

    if result.code ~= 0 then
      vim.notify(
        "[hacks.nvim] npm install failed:\n" .. (result.stderr or ""),
        vim.log.levels.ERROR
      )
    else
      vim.notify("[hacks.nvim] inline-js-ls install complete")
    end
  end,
  opts = {
    inline_js_ls = { enabled = true, filetypes = {"html", "htmldjango"} },
    pdf = { enabled = true },
    mouse = { enabled = true },
    colorify = { enabled = true },
  },
  keys = {
    -- Terminal
    { "<leader>th", function() require("hacks.term").new({ pos = "sp" }) end, desc = "Spawn horizontal terminal" },
    { "<leader>tv", function() require("hacks.term").new({ pos = "vsp" }) end, desc = "Spawn vertical terminal" },
    {
      "<leader>,",
      function()
        local enable_neo_tree = true
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neo-tree" then
            enable_neo_tree = false
            break
          end
        end
        require("hacks.term").new({ pos = "sp" })
        require("hacks.term").new({ pos = "vsp" })
        if enable_neo_tree then
          vim.cmd("Neotree show")
        end
      end,
      desc = "Spawn splitted horizontal terminal",
    },
    {
      "<leader>td",
      function()
        local term_buf = vim.api.nvim_get_current_buf()
        -- make sure we are in a terminal
        if vim.bo[term_buf].buftype ~= "terminal" then
          print("Not a terminal buffer!")
          return
        end
        -- Find project root (where manage.py is)
        local manage_py = vim.fn.findfile("manage.py", vim.fn.getcwd() .. "/**")
        if root == "" then
          print("manage.py not found")
          return
        end
        
        local django_dir = vim.fn.fnamemodify(manage_py, ":h")
        -- Send commands to the terminal
        local cmds = {
          "cd " .. django_dir,
          "python manage.py runserver"
        }
        for _, cmd in ipairs(cmds) do
          vim.api.nvim_chan_send(vim.b[term_buf].terminal_job_id, cmd .. "\n")
        end
        -- make sure terminal stays in insert mode
        vim.cmd("startinsert")
        end, 
        desc = "Run django in terminal"
    },
  },
}