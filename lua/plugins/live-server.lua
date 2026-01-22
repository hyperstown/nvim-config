return {
  "hyperstown/nvim-live-server",
  cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle"},
  lazy = false,
  opts = {
    host = "127.0.0.1",
    port = 5550,
    conn_attempts = 3,
  },
}