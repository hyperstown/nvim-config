-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- TODO move to files
vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })


-- not really sure where I should put this

local function refresh_neotree_git()
  local ok, gs = pcall(require, "neo-tree.sources.git_status")
  if ok then gs.refresh() end
end

local timer
local function debounce(fn, ms)
  return function()
    if timer then timer:stop() end
    timer = vim.uv.new_timer()
    timer:start(ms, 0, vim.schedule_wrap(fn))
  end
end

local git_dir = vim.fn.systemlist("git rev-parse --git-dir")[1]
if git_dir and git_dir ~= "" then
  local handle = vim.uv.new_fs_event()
  handle:start(git_dir, {}, debounce(refresh_neotree_git, 100))
end
