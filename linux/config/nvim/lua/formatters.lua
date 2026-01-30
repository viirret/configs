local M = {}

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
        nix = { "nixpkgs-fmt" },
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
        rustfmt = {
            prepend_args = { "--edition", "2021" },
        },
        clang_format = {
            prepend_args = {},
        },
        nixpkgs_fmt = {
            prepend_args = {},
        },
        tex_fmt = {
            prepend_args = {},
        },
        cmake_format = {
            prepend_args = {},
        },
        shfmt = {
            prepend_args = {},
        },
    },

    -- Executable names, might differ from formatter name
    executables = {
        stylua = "stylua",
        black = "black",
        gofumpt = "gofumpt",
        prettier = "prettier",
        rustfmt = "rustfmt",
        nixpkgs_fmt = "nixpkgs-fmt",
        clang_format = "clang-format",
        tex_fmt = "tex-fmt",
        cmake_format = "cmake-format",
        shfmt = "shfmt",
    },
}

-- Helper to check if formatter is available
function M.is_available(filetype)
    local formatters = M.definitions.by_filetype[filetype]
    if not formatters then
        return false
    end

    -- Check if at least one formatter is available
    for _, formatter_name in ipairs(formatters) do
        local executable = M.definitions.executables[formatter_name] or formatter_name
        if vim.fn.executable(executable) == 1 then
            return true
        end
    end

    return false
end

-- Get available formatters for a filetype
function M.get_for_filetype(filetype)
    return M.definitions.by_filetype[filetype] or {}
end

-- Get executable name for a formatter
function M.get_executable(formatter_name)
    return M.definitions.executables[formatter_name] or formatter_name
end

-- Get configuration for a formatter
function M.get_config(formatter_name)
    return M.definitions.configs[formatter_name] or {}
end

-- Check if specific formatter is executable
function M.is_formatter_executable(formatter_name)
    local executable = M.get_executable(formatter_name)
    return vim.fn.executable(executable) == 1
end

-- Get all formatter definitions for conform
function M.for_conform()
    return {
        formatters_by_ft = M.definitions.by_filetype,
        formatters = M.definitions.configs,
    }
end

-- Get formatter_avainable table for on_attach
function M.get_available_table()
    local available = {}
    for filetype, _ in pairs(M.definitions.by_filetype) do
        available[filetype] = M.is_available(filetype)
    end
    return available
end

return M
