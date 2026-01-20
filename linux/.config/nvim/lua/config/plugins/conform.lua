return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                go = { "gofumpt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                rust = { "rustfmt" },
                nix = { "nixpkgs-fmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                tex = { "latexindent" },
                cmake = { "cmake_format" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
            },

            -- Formatter configuration
            formatters = {
                gofumpt = {
                    prepend_args = { "-extra" },
                },
                stylua = {
                    prepend_args = {},
                },
                prettier = {
                    prepend_args = {},
                },
                black = {
                    prepend_args = { "--quiet" },
                },
                rustfmt = {
                    prepend_args = { "--edition", "2021" },
                },
                clang_format = {
                    prepend_args = {},
                },
            },

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
