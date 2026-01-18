local M = {}

function M.is_nixos()
    local f = io.open("/etc/os-release", "r")
    if not f then
        return false
    end
    local content = f:read "*a"
    f:close()
    return content:match "ID=nixos" ~= nil
end

return M
