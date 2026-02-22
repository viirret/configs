return {
    "neovim/nvim-lspconfig",
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = require("on_attach").on_attach

        local lsp_dir = vim.fn.stdpath("config") .. "/lua/config/plugins/lsp"
        for _, file in ipairs(vim.fn.glob(lsp_dir .. "/*.lua", false, true)) do
            local name = vim.fn.fnamemodify(file, ":t:r")
            require("config.plugins.lsp." .. name).setup(capabilities, on_attach)
        end
    end,
}
