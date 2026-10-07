local formatters = require "formatters"

return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Format", "FormatToggle", "FormatToggleBuffer", "Formatters", "ConformInfo" },
    config = function()
        local formatter_defs = formatters.for_conform()

        require("conform").setup {
            formatters_by_ft = formatter_defs.formatters_by_ft,
            formatters = formatter_defs.formatters,
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                require("utils.editorconfig").reload(bufnr)
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
        }

        local helpers = require "on_attach"
        vim.api.nvim_create_user_command("Format", function()
            helpers.format_with_conform()
        end, { desc = "Format current buffer" })
        vim.api.nvim_create_user_command("FormatToggle", function()
            helpers.toggle_auto_format(false)
        end, { desc = "Toggle format on save globally" })
        vim.api.nvim_create_user_command("FormatToggleBuffer", function()
            helpers.toggle_auto_format(true)
        end, { desc = "Toggle format on save for this buffer" })
        vim.api.nvim_create_user_command("Formatters", function()
            helpers.show_available_formatters()
        end, { desc = "Show current buffer's formatter availability" })
    end,
}
