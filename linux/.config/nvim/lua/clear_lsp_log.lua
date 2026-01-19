-- Function to clear the LSP log if it exceeds the size limit or on startup
local M = {}

M.clear_lsp_log = function()
    local log_path = vim.lsp.get_log_path()

    if log_path and vim.fn.filereadable(log_path) == 1 then
        local max_size = 50000 -- 50 KB

        local file_size = vim.fn.getfsize(log_path)
        if file_size > max_size then
            -- Delete the log file if it exceeds the max size.
            os.remove(log_path)
            print "LSP log file exceeded size limit and was deleted."
        else
            -- Clear the log file every time Neovim is started.
            os.remove(log_path)
        end
    end
end

return M
