local M = {}

--- Build a native LSP root callback from project markers.
---@param patterns string[]
---@return function
function M.make_root_dir(patterns)
    return function(bufnr, on_dir)
        if vim.bo[bufnr].buftype ~= "" then
            return
        end
        local filename = vim.api.nvim_buf_get_name(bufnr)
        on_dir(require("utils.root_dir").get_root_dir(filename, patterns))
    end
end

---@param opts table
function M.build(opts)
    vim.lsp.config(opts.name, {
        cmd = opts.cmd,
        capabilities = opts.capabilities,
        on_attach = opts.on_attach,
        filetypes = opts.filetypes or {},
        root_dir = opts.root_dir or M.make_root_dir(opts.root_patterns or {}),
        settings = opts.settings or {},
        init_options = opts.init_options,
    })
    vim.lsp.enable(opts.name)
end

return M
