local function reset_all_done_to_todo()
    -- Safety guard: only run in org buffers
    if vim.bo.filetype ~= "org" then
        vim.notify("This command only works in .org files", vim.log.levels.WARN)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local modified = false

    for i, line in ipairs(lines) do
        -- Match headlines "* DONE"to "** DONE"
        if line:match "^(%*+)%s+DONE" then
            lines[i] = (line:gsub("^(%*+)%s+DONE", "%1 TODO"))
            modified = true
        end
    end

    if modified then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.notify "Reset all DONE tasks back to TODO!"
    else
        vim.notify "No DONE tasks found to reset."
    end
end

return {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    config = function()
        require("orgmode").setup {
            org_agenda_files = "~/orgfiles/**/*",
            org_default_notes_file = "~/orgfiles/refile.org",
        }

        -- Buffer-local keymap, set only when an org buffer is opened.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("OrgResetDone", { clear = true }),
            pattern = "org",
            callback = function(args)
                vim.keymap.set("n", "<leader>rt", reset_all_done_to_todo, {
                    buffer = args.buf,
                    desc = "Orgmode: Reset all DONE tasks to TODO",
                })
            end,
        })

        -- Enable built-in LSP capabilities for Org.
        vim.lsp.enable "org"
    end,
}
