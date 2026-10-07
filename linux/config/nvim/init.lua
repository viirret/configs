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
    require("utils.lsp_status").show()
end, { desc = "Show buffer LSP roots, commands, and formatters" })
