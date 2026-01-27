return {
  "ghillb/cybu.nvim",
  branch = "main",
  keys = {
    { "K", "<Plug>(CybuPrev)", mode = "n", desc = "Cybu Prev" },
    { "J", "<Plug>(CybuNext)", mode = "n", desc = "Cybu Next" },
    { "<c-s-tab>", "<plug>(CybuLastusedPrev)", mode = { "n", "v" }, desc = "Cybu Last Used Prev" },
    { "<c-tab>", "<plug>(CybuLastusedNext)", mode = { "n", "v" }, desc = "Cybu Last Used Next" },
  },
  opts = {
    display_time = 250
  }, -- automatically calls require("cybu").setup()
}
