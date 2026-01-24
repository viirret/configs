local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "pylsp",
        cmd = { "pylsp" },
        filetypes = { "python" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { "pyproject.toml", "setup.py", ".git" },
        settings = {
            pylsp = {
                plugins = {
                    pyflakes = { enabled = true },
                    pycodestyle = { enabled = true },
                    black = { enabled = false },
                    ruff = { enabled = true },
                    pylsp_mypy = { enabled = false },
                },
            },
        },
    }
end

return M
