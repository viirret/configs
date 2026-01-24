local builder = require "config.plugins.lsp.lspbuilder"

local M = {}

function M.setup(capabilities, on_attach)
    builder.build {
        name = "nixd",
        cmd = { "nixd" },
        filetypes = { "nix" },
        capabilities = capabilities,
        on_attach = on_attach,
        root_patterns = { "flake.nix", "default.nix", ".git" },
        settings = {
            nixd = {
                nixpkgs = { expr = "import <nixpkgs> { }" },
                formatting = { command = { "nixfmt" } },
            },
        },
    }
end

return M
