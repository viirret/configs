local M = {}

--- Safe wrapper around vim.loop.fs_stat
--- Returns the stat table or nil (no warnings or errors)
---@param path string
---@return table|nil
function M.safe_stat(path)
    if not path or path == "" then
        return nil
    end
    local ok, stat = pcall(vim.loop.fs_stat, path)
    if ok then
        return stat
    end
    return nil
end

--- Check if a path exists
---@param path string
---@return boolean
function M.exists(path)
    return M.safe_stat(path) ~= nil
end

return M
