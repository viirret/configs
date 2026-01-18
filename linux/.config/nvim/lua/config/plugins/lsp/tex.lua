-- lua/lsp/latex.lua
local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "texlab",
        cmd = { "texlab" },
        filetypes = { "tex", "bib" },
        root_patterns = { ".git", ".latexmkrc" },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            texlab = {
                build = {
                    executable = "latexmk",
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                    onSave = true,
                },
                forwardSearch = {
                    executable = "evince",
                    args = { "--synctex-forward", "%l:1:%f", "%p" },
                },
                chktex = {
                    onOpenAndSave = true,
                    onEdit = false,
                },
            },
        },
    }
end

return M
