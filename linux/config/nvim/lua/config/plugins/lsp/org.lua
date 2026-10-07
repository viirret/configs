local M = {}

function M.setup(capabilities, on_attach)
    -- Orgmode provides the server when its plugin loads for an org buffer.
    vim.lsp.config("org", {
        capabilities = capabilities,
        on_attach = on_attach,
    })
end

return M
