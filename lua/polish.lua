-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here


-- TODO create autocmd that executes when git watcher is triggered
-- api.nvim_exec_autocmds('User', {
--   pattern = 'GitChangesUpdate',
-- })
-- Then add watchers for neo-tree and hierline
local function refresh_neotree_git()
  local ok, gs = pcall(require, "neo-tree.sources.git_status")
  if ok then gs.refresh() end
end

local function refresh_git_changes()
  vim.fn.jobstart({ 'git', 'rev-list', '--count', '--left-right', 'HEAD...@{upstream}' }, {
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        vim.g.git_changes = vim.split(vim.trim(data[1]), "\t")
        vim.cmd("redrawstatus")
      end
    end,
  })
end

local function debounce(fn, ms)
  return require('gitsigns.debounce').debounce_trailing(ms, vim.schedule_wrap(fn))
end

local git_dir = vim.fn.systemlist("git rev-parse --git-dir")[1]
if git_dir and git_dir ~= "" then
  local handle = vim.uv.new_fs_event()
  local tree_refresh = debounce(refresh_neotree_git, 100)
  local status_refresh = debounce(refresh_git_changes, 500)
  handle:start(git_dir, {}, function() 
    tree_refresh()
    status_refresh()
  end)
end

vim.api.nvim_create_autocmd("VimEnter", {callback = refresh_git_changes})



-- Additional useful keymaps
vim.keymap.set("v", "(", [[c(<C-R>")<ESC>]])
vim.keymap.set("v", "{", [[c{<C-R>"}<ESC>]])
vim.keymap.set("v", "[", [[c[<C-R>"]<ESC>]])

vim.keymap.set("v", "'", [[c'<C-R>"'<ESC>]])
vim.keymap.set("v", '"', [[c"<C-R>""<ESC>]])
vim.keymap.set("v", '`', [[c`<C-R>"`<ESC>]])

vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
