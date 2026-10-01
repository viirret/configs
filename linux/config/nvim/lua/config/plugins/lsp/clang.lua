local builder = require "utils.lspbuilder"
local is_nixos = require("utils.is_nixos").is_nixos

local M = {}

function M.setup(capabilities, on_attach)
    local cmd = { "clangd", "--header-insertion=never" }
    if is_nixos() then
        table.insert(
            cmd,
            "--query-driver=/nix/store/*-gcc-wrapper-*/bin/*,/nix/store/*-clang-wrapper-*/bin/*,/etc/profiles/**/bin/*,/run/current-system/sw/bin/*,/usr/bin/c++,/usr/bin/g++"
        )
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
