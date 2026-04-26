if not vim then
    error "This config must be run inside Neovim"
end

-- Keys
require "keys.keys"
require "keys.barbar"

-- Global options
require "opts"

-- Lazy config
require "config.lazy"

-- rotate at 512 KB
require("lsp_log_rotate").rotate_lsp_log(512)

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
