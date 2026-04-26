local M = {}

M.rotate_lsp_log = function(max_size_kb)
    max_size_kb = max_size_kb or 1024 -- default 1 MB
    local max_size_bytes = max_size_kb * 1024

    local log_path = require("vim.lsp.log").get_filename()
    if not log_path or vim.fn.filereadable(log_path) == 0 then
        return
    end

    local file_size = vim.fn.getfsize(log_path)
    if file_size > max_size_bytes then
        -- Rotate: move current log to .old, then create new empty log
        local old_path = log_path .. ".old"
        os.remove(old_path) -- delete previous backup if any
        os.rename(log_path, old_path) -- rotate current log to backup
        -- Touch a new empty log file (Neovim will recreate it on next write)
        io.open(log_path, "w"):close()
        print(string.format("LSP log rotated (was %.1f MB)", file_size / 1048576))
    end
end

return M
