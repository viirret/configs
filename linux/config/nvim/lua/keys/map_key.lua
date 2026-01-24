local M = {}

function M.set(mode, lhs, rhs, opts)
    opts = opts or {}
    local defaults = {
        noremap = true,
        silent = opts.silent ~= false,
    }

    -- Handle buffer-local keymaps
    if opts.buffer then
        local bufnr = type(opts.buffer) == "number" and opts.buffer or 0
        opts.buffer = nil
        return pcall(vim.keymap.set, mode, lhs, rhs, vim.tbl_extend("force", defaults, opts, { buffer = bufnr }))
    end

    return pcall(vim.keymap.set, mode, lhs, rhs, vim.tbl_extend("force", defaults, opts))
end

return M
