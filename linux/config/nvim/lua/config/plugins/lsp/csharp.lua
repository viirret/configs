local M = {}

local function find_root(fname)
    local dir = fname ~= "" and vim.fs.dirname(fname) or vim.fn.getcwd()
    local found = vim.fs.find(function(name)
        return name:match "%.sln$" or name:match "%.csproj$"
    end, { upward = true, path = dir, limit = 1 })
    if found[1] then
        return vim.fs.dirname(found[1])
    end
    return require("utils.root_dir").get_root_dir(fname, { ".git" })
end

function M.setup(capabilities, on_attach)
    require("utils.lspbuilder").build {
        name = "csharp_ls",
        cmd = { vim.fn.expand "~/.dotnet/tools/csharp-ls" },
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "cs" },
        root_dir = function(bufnr, on_dir)
            if vim.bo[bufnr].buftype == "" then
                on_dir(find_root(vim.api.nvim_buf_get_name(bufnr)))
            end
        end,
    }
end

return M
