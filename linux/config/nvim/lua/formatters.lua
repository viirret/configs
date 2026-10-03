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
        ["clang-format"] = "clang-format",
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
