local M = {}

function M.setup(bufnr)
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
    map("n", "gr", vim.lsp.buf.references, "LSP: Find references")
    map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "LSP: Go to type definition")
    map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
    map("n", "K", vim.lsp.buf.hover, "LSP: Hover documentation")
    map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostics")
    map("n", "<leader>ih", function()
        local filter = { bufnr = bufnr }
        local clients = vim.lsp.get_clients { bufnr = bufnr, method = "textDocument/inlayHint" }
        if #clients == 0 then
            vim.notify("No attached LSP supports inlay hints", vim.log.levels.INFO)
            return
        end
        local enabled = not vim.lsp.inlay_hint.is_enabled(filter)
        vim.lsp.inlay_hint.enable(enabled, filter)
        vim.notify("Inlay hints: " .. (enabled and "ENABLED" or "DISABLED"))
    end, "LSP: Toggle inlay hints")
end

return M
