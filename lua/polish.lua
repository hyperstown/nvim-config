-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- TODO move to files
vim.g.copilot_filetypes = vim.tbl_extend("force", vim.g.copilot_filetypes or {}, {
  env = false,
  sh = false,
  json = false,
})
vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })
