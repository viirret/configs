local M = {}

function M.show()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = { "LSP status for " .. (vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].filetype or "untyped buffer") }
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    table.sort(clients, function(a, b)
        return a.name < b.name
    end)
    if #clients == 0 then
        lines[#lines + 1] = "No active LSP clients"
    end
    for _, client in ipairs(clients) do
        local cmd = client.config.cmd
        lines[#lines + 1] = client.name
        lines[#lines + 1] = "  Root: " .. (client.config.root_dir or "single file")
        lines[#lines + 1] = "  Command: " .. (type(cmd) == "table" and vim.inspect(cmd) or "in-process server")
        lines[#lines + 1] = "  Formatting: "
            .. (client:supports_method("textDocument/formatting", bufnr) and "yes" or "no")
    end

    local conform = require "conform"
    local formatters = conform.list_formatters(bufnr)
    lines[#lines + 1] = "External formatters:"
    if #formatters == 0 then
        lines[#lines + 1] = "  None configured"
    end
    for _, formatter in ipairs(formatters) do
        local status = formatter.available and "available" or (formatter.available_msg or "unavailable")
        lines[#lines + 1] = "  " .. formatter.name .. ": " .. status
        if formatter.command then
            lines[#lines + 1] = "    Command: " .. formatter.command
        end
    end
    local enabled = not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat)
    lines[#lines + 1] = "Format on save: " .. (enabled and "enabled" or "disabled")
    print(table.concat(lines, "\n"))
end

return M
