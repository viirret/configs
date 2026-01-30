local formatters = require "formatters"

return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local formatter_defs = formatters.for_conform()

        require("conform").setup {
            formatters_by_ft = formatter_defs.formatters_by_ft,
            formatters = formatter_defs.formatters,

            -- Format on save
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true, -- Fall back to LSP formatting if no formatter is configured
            },
        }

        -- Apply EditorConfig before formatting
        local conform = require "conform"
        local original_format = conform.format

        conform.format = function(opts)
            -- Apply EditorConfig before formatting
            vim.cmd "silent! EditorConfigReload"
            original_format(opts)
        end
    end,
}
