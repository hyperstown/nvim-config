return {
  "nvimtools/none-ls.nvim",
  keys = { { "<leader>la", vim.lsp.buf.code_action, desc = "Code action" } },
  opts = function(_, opts)
    -- hmm this is not really none-ls but it's lsp config and and astrolsp doesn't work
    vim.lsp.config("codebook", {
      cmd = { "codebook-lsp", "serve" },
    })
    vim.lsp.enable("codebook")
  end,
}
