local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "vtsls",
        cmd = { "vtsls", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
        settings = {
            typescript = {
                updateImportsOnRename = "always",
                suggest = { completeFunctionCalls = true },
            },
            javascript = {
                updateImportsOnRename = "always",
            },
        },
    }
end

return M
