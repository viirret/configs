local M = {}

-- Default C/C++ formatting rules, used when the project has no .clang-format.
-- Override the location with $CLANG_FORMAT_DEFAULT.
local DEFAULT_CLANG_FORMAT = os.getenv "CLANG_FORMAT_DEFAULT"
    or (vim.fn.stdpath "config" .. "/clang-format-default/.clang-format")

-- Filenames clang-format looks for, in the file's directory and its parents.
-- The ".clang-format-<tuple>" variants only matter for clang-format's
-- fuzzing/syntax-only modes, which are not used here.
local CLANG_FORMAT_CONFIGS = { ".clang-format", "_clang-format" }

-- Mirror clang-format's own config lookup: walk up from the buffer's
-- directory to the filesystem root looking for a config file.
local function has_project_clang_format(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" then
        return false
    end

    local dir = vim.fs.dirname(filename)
    while dir do
        for _, config_name in ipairs(CLANG_FORMAT_CONFIGS) do
            if vim.fn.filereadable(dir .. "/" .. config_name) == 1 then
                return true
            end
        end
        local parent = vim.fs.dirname(dir)
        if not parent or parent == dir then
            break
        end
        dir = parent
    end

    return false
end

-- Centralized formatter definitions
M.definitions = {
    -- Formatter filetypes
    by_filetype = {
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
        nix = { "nixpkgs_fmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        tex = { "tex-fmt" },
        cmake = { "cmake_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
    },

    -- Formatter configurations
    configs = {
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

        -- clang-format only looks for .clang-format next to the file and its
        -- parents, so point it at our default when the project has none.
        -- conform.nvim calls this with the buffer number, which lets the
        -- decision be made per buffer.
        ["clang-format"] = function(bufnr)
            if has_project_clang_format(bufnr) then
                return {}
            end
            return { prepend_args = { "--style=file:" .. DEFAULT_CLANG_FORMAT } }
        end,
        nixpkgs_fmt = {
            prepend_args = {},
        },
        ["tex-fmt"] = {
            prepend_args = {},
        },
        cmake_format = {
            prepend_args = {},
        },
        shfmt = {
            prepend_args = {},
        },
    },
}

-- Get all formatter definitions for conform
function M.for_conform()
    return {
        formatters_by_ft = M.definitions.by_filetype,
        formatters = M.definitions.configs,
    }
end

return M
