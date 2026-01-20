local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "bashls",
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash", "zsh" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { ".git" },
    }
end

return M
