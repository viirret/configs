if not vim then
    error "This config must be run inside Neovim"
end

-- Global keys
require "keys.keys"

-- Global options
require "opts"

-- Lazy config
require "config.lazy"

local clear_lsp_log = require "clear_lsp_log"
clear_lsp_log.clear_lsp_log_if_needed()

vim.api.nvim_create_user_command("LspStatus", function()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then
        print "No active LSP clients"
    else
        for _, client in ipairs(clients) do
            print("Active LSP: " .. client.name)
        end
    end
end, {})
