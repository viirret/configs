local M = {}

local function find_root(fname)
    local dir = vim.fs.dirname(fname)
    local found = vim.fs.find(function(name)
        return name:match("%.sln$") or name:match("%.csproj$")
    end, { upward = true, path = dir, limit = 1 })
    if found[1] then
        return vim.fs.dirname(found[1])
    end
    local git = vim.fs.find(".git", { upward = true, path = dir })[1]
    return git and vim.fs.dirname(git) or vim.fn.getcwd()
end

function M.setup(capabilities, on_attach)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "cs" },
        callback = function(args)
            local active = vim.lsp.get_clients { bufnr = args.buf, name = "csharp_ls" }
            if #active == 0 then
                local root = find_root(vim.api.nvim_buf_get_name(args.buf))
                vim.lsp.start {
                    name = "csharp_ls",
                    cmd = { vim.fn.expand("~/.dotnet/tools/csharp-ls") },
                    capabilities = capabilities,
                    on_attach = on_attach,
                    root_dir = root,
                    settings = {},
                }
            end
        end,
    })
end

return M
