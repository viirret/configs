local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "marksman",
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { ".git", ".marksman.toml" },
    }
end

return M
