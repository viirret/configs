local M = {}

function M.reload(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if vim.b[bufnr].editorconfig == false or (vim.b[bufnr].editorconfig == nil and vim.g.editorconfig == false) then
        return
    end
    require("editorconfig").config(bufnr)
end

return M
