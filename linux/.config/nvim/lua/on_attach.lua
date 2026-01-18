local lsp_keymaps = require "keys.lsp_keymaps"

local M = {}

local FORMATTER_AVAILABLE = {
    lua = vim.fn.executable "stylua" == 1,
    python = vim.fn.executable "black" == 1,
    go = vim.fn.executable "gofumpt" == 1,
    javascript = vim.fn.executable "prettier" == 1,
    typescript = vim.fn.executable "prettier" == 1,
    json = vim.fn.executable "prettier" == 1,
    markdown = vim.fn.executable "prettier" == 1,
    c = vim.fn.executable "clang-format" == 1,
    cpp = vim.fn.executable "clang-format" == 1,
    rust = vim.fn.executable "rustfmt" == 1,
    nix = vim.fn.executable "nixpkgs-fmt" == 1,
    sh = vim.fn.executable "shfmt" == 1,
    cmake = vim.fn.executable "cmake-format" == 1,
    tex = vim.fn.executable "latexindent" == 1,
}

function M.on_attach(client, bufnr)
    lsp_keymaps.setup(bufnr)

    -- Disable LSP formatting for filetypes handled by conform
    local ft = vim.bo[bufnr].filetype
    if client.supports_method "textDocument/formatting" and FORMATTER_AVAILABLE[ft] then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end
end

-- Format using conform.nvim
function M.format_with_conform(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    -- Apply EditorConfig (conform.format already does this, but just in case)
    vim.cmd "silent! EditorConfigReload"

    -- Check if we're in visual mode
    local mode = vim.api.nvim_get_mode().mode

    if mode == "v" or mode == "V" or mode == "" then
        -- Visual mode: format selection
        local start_line = vim.fn.line "v"
        local start_col = vim.fn.col "v"
        local end_line = vim.fn.line "."
        local end_col = vim.fn.col "."

        require("conform").format {
            bufnr = bufnr,
            range = {
                start = { start_line, start_col },
                ["end"] = { end_line, end_col },
            },
            async = false,
        }
    else
        -- Normal mode: format entire buffer
        require("conform").format {
            bufnr = bufnr,
            async = false,
        }
    end
end

-- Toggle auto-format on save (now handled by conform)
function M.toggle_auto_format()
    local conform = require "conform"
    local current_setting = conform.format_on_save

    if current_setting then
        conform.format_on_save = false
        vim.notify("Auto-format on save: DISABLED", vim.log.levels.INFO)
    else
        conform.format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        }
        vim.notify("Auto-format on save: ENABLED", vim.log.levels.INFO)
    end
end

-- Helper to check available formatters
function M.show_available_formatters(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype

    local has_conform, conform = pcall(require, "conform")
    if not has_conform then
        vim.notify("conform.nvim not available", vim.log.levels.WARN)
        return
    end

    local config = conform.get_config(bufnr)
    local formatter_names = {}

    if config and config.formatters_by_ft and config.formatters_by_ft[ft] then
        formatter_names = config.formatters_by_ft[ft]
    end

    if #formatter_names > 0 then
        local msg = "Formatters for " .. ft .. ": "
        for i, fmt_name in ipairs(formatter_names) do
            -- Check if formatter is available
            local fmt_config = conform.formatters[fmt_name]
            local available = "✓"
            if fmt_config and fmt_config.command then
                local cmd = fmt_config.command
                if type(cmd) == "function" then
                    cmd = cmd()
                end
                if vim.fn.executable(cmd) == 0 then
                    available = "✗"
                end
            end

            msg = msg .. fmt_name .. " " .. available
            if i < #formatter_names then
                msg = msg .. ", "
            end
        end
        vim.notify(msg, vim.log.levels.INFO)
    else
        vim.notify("No formatters configured for " .. ft, vim.log.levels.WARN)
    end
end

return M
