return {
    "neovim/nvim-lspconfig",
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = require("on_attach").on_attach

        require("config.plugins.lsp.lua").setup(capabilities, on_attach)
        require("config.plugins.lsp.python").setup(capabilities, on_attach)
        require("config.plugins.lsp.rust").setup(capabilities, on_attach)
        require("config.plugins.lsp.nix").setup(capabilities, on_attach)
        require("config.plugins.lsp.clang").setup(capabilities, on_attach)
        require("config.plugins.lsp.typescript").setup(capabilities, on_attach)
        require("config.plugins.lsp.cmake").setup(capabilities, on_attach)
        require("config.plugins.lsp.tex").setup(capabilities, on_attach)
        require("config.plugins.lsp.go").setup(capabilities, on_attach)
    end,
}
