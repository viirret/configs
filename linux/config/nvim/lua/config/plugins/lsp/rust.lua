local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "rust_analyzer",
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { "Cargo.toml", ".git" },
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
                diagnostics = { enable = true },
            },
        },
    }
end

return M
