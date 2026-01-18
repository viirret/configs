local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "cmake",
        cmd = { "cmake-language-server" },
        filetypes = { "cmake", "CMakeLists.txt" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = {
            "CMakeLists.txt",
            ".git",
            "build",
            "CMakePresets.json",
        },
        settings = {
            cmake = {
                configureOnOpen = true,
                configureOnEdit = false,
                buildDirectory = "build",
                generator = nil,
            },
        },
    }
end

return M
