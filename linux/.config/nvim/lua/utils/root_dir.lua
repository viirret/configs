local M = {}

-- Accepts the current file path and a table of marker files
function M.get_root_dir(fname, markers)
    local root = vim.fs.find(markers, { upward = true, path = fname })[1]

    -- Return directory of the marker, or fallback to current directory of the file
    return root and vim.fs.dirname(root) or vim.fs.dirname(fname) or vim.fn.getcwd()
end

return M
