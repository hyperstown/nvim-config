return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      local astrocore = require "astrocore"

      return astrocore.extend_tbl(opts, {
        formatting = {
          disabled = { -- disable formatting capabilities for the listed language servers
            "volar",
          },
        },
        config = {
          volar = {
            on_init = function(client)
              client.handlers["tsserver/request"] = function(_, result, context)
                local clients = vim.lsp.get_clients {
                  bufnr = context.bufnr,
                  name = "vtsls",
                }

                if #clients == 0 then
                  vim.notify(
                    "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                    vim.log.levels.ERROR
                  )
                  return
                end

                local ts_client = clients[1]
                local param = unpack(result)
                local id, command, payload = unpack(param)

                ts_client:exec_cmd({
                  title = "vue_request_forward",
                  command = "typescript.tsserverRequest",
                  arguments = { command, payload },
                }, { bufnr = context.bufnr }, function(_, r)
                  if not r then return end -- ADDING 50 lines of code just to change this line!

                  local response_data = { { id, r.body } }
                  client:notify("tsserver/response", response_data)
                end)
              end
            end,
          },
        },
      })
    end,
  },
}
