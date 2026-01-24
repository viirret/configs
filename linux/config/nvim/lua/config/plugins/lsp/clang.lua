local builder = require "config.plugins.lsp.lspbuilder"
local is_nixos = require("utils.is_nixos").is_nixos

local M = {}

function M.setup(capabilities, on_attach)
    local cmd = { "clangd", "--header-insertion=never" }
    if is_nixos() then
        table.insert(cmd, "--query-driver=/nix/store/*-gcc-*/bin/g++")
    end
    builder.build {
        name = "clangd",
        cmd = cmd,
        filetypes = { "c", "cpp", "objc", "objcpp" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { "compile_commands.json", ".clangd", ".git" },
        settings = {
            clangd = {},
        },
    }
end

return M
