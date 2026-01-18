local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "gopls",
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { "go.mod", ".git" },
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                    unusedwrite = true,
                    useany = true,
                    unusedvariable = true,
                    fieldalignment = false,
                    nilness = true,
                    unusedresult = true,
                    staticcheck = true,
                    printf = true,
                },
                codelenses = {
                    generate = true,
                    gc_details = false,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                    regenerate_cgo = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                gofumpt = true, -- Enable gofumpt formatting
                semanticTokens = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
        init_options = {
            usePlaceholders = true,
        },
    }
end

return M
