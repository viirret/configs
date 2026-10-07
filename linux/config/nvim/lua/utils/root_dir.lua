local M = {}

M.project_markers =
    { ".git", "Cargo.toml", "go.work", "go.mod", "pyproject.toml", "package.json", "flake.nix", "CMakeLists.txt" }

-- Search from the file's directory; standalone files use that directory too.
function M.get_root_dir(fname, markers)
    local dir = fname ~= "" and vim.fs.dirname(fname) or vim.fn.getcwd()
    local root = vim.fs.find(markers, { upward = true, path = dir })[1]
    return root and vim.fs.dirname(root) or dir
end

function M.current_project()
    return M.get_root_dir(vim.api.nvim_buf_get_name(0), M.project_markers)
end

return M
