local lsp_keymaps = require "keys.lsp_keymaps"

local M = {}

function M.on_attach(_, bufnr)
    lsp_keymaps.setup(bufnr)
end

-- Conform detects and normalizes the active visual selection itself.
function M.format_with_conform(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    require("utils.editorconfig").reload(bufnr)
    return require("conform").format { bufnr = bufnr, async = false, lsp_format = "fallback" }
end

function M.toggle_auto_format(buffer_local)
    local scope = buffer_local and vim.b or vim.g
    scope.disable_autoformat = not scope.disable_autoformat
    local label = buffer_local and "buffer" or "global"
    vim.notify("Auto-format on save (" .. label .. "): " .. (scope.disable_autoformat and "DISABLED" or "ENABLED"))
end

function M.show_available_formatters(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local entries = require("conform").list_formatters(bufnr)
    local names = {}
    for _, formatter in ipairs(entries) do
        names[#names + 1] = formatter.name .. (formatter.available and " ✓" or " ✗")
    end
    vim.notify(
        #names > 0 and table.concat(names, ", ")
            or "No external formatters configured; see :ConformInfo for LSP fallback"
    )
end

return M
