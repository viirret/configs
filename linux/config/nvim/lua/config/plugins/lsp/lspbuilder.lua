local M = {}

--- Root_dir finder
---@param patterns string[]
---@return function
function M.make_root_dir(patterns)
    return function(fname)
        local root = vim.fs.find(patterns, { upward = true, path = fname })[1]
        return root and vim.fs.dirname(root) or vim.fn.getcwd()
    end
end

---@param opts table
function M.build(opts)
    local name = opts.name
    local cmd = opts.cmd
    local filetypes = opts.filetypes or {}
    local settings = opts.settings or {}
    local capabilities = opts.capabilities
    local on_attach = opts.on_attach
    local root_patterns = opts.root_patterns or {}
    local root_dir_fn = M.make_root_dir(root_patterns)

    vim.lsp.config[name] = {
        cmd = cmd,
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = filetypes,
        root_dir = root_dir_fn,
        settings = settings,
    }

    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(args)
            local active = vim.lsp.get_clients { bufnr = args.buf, name = name }
            if #active == 0 then
                local root = root_dir_fn(args.file)
                vim.lsp.start {
                    name = name,
                    cmd = cmd,
                    capabilities = capabilities,
                    on_attach = on_attach,
                    root_dir = root,
                    settings = settings,
                }
            end
        end,
    })
end

return M
