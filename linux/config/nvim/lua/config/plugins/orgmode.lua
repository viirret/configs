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
        -- Match the whole TODO keyword, including headlines with no title.
        if line:match "^%*+%s+DONE%s" or line:match "^%*+%s+DONE$" then
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

local function unfold_all_org()
    local count = 0
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "org" then
                vim.wo[win].foldlevel = 99
                count = count + 1
            end
        end
    end
    vim.notify(("Unfolded %d org window(s)"):format(count))
end

local function warn_if_not_org()
    if vim.bo.filetype ~= "org" then
        vim.notify("This command only works in .org files", vim.log.levels.WARN)
        return true
    end
    return false
end

-- TODO -> DONE, only on the given line range (default: cursor line)
local function mark_todo_done(first, last)
    if warn_if_not_org() then
        return
    end

    first = first or vim.api.nvim_win_get_cursor(0)[1]
    last = last or first

    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    local count = 0

    for i, line in ipairs(lines) do
        if line:match "^%*+%s+TODO%s" or line:match "^%*+%s+TODO$" then
            lines[i] = line:gsub("^(%*+)%s+TODO", "%1 DONE")
            count = count + 1
        end
    end

    if count > 0 then
        vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
        vim.notify(("Marked %d task(s) as DONE"):format(count))
    else
        vim.notify "No TODO headline on that line."
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

        local function set_org_keymaps(bufnr)
            -- Buffer-local keymaps for the org buffer being opened.
            vim.keymap.set("n", "<leader>rd", function()
                mark_todo_done()
            end, {
                buffer = bufnr,
                desc = "Orgmode: Mark current TODO as DONE",
            })

            -- Visual mode: every TODO inside the selection
            vim.keymap.set("x", "<leader>rd", function()
                local a, b = vim.fn.line "v", vim.fn.line "."
                if a > b then
                    a, b = b, a
                end
                vim.cmd "normal! \27" -- leave visual mode
                mark_todo_done(a, b)
            end, {
                buffer = bufnr,
                desc = "Orgmode: Mark selected TODOs as DONE",
            })

            -- Whole file
            vim.keymap.set("n", "<leader>rt", reset_all_done_to_todo, {
                buffer = bufnr,
                desc = "Orgmode: Reset all DONE to TODO",
            })

            vim.keymap.set("n", "<leader>re", unfold_all_org, {
                buffer = bufnr,
                desc = "Orgmode: Unfold everything in all org windows",
            })
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("OrgResetDone", { clear = true }),
            pattern = "org",
            callback = function(args)
                set_org_keymaps(args.buf)
            end,
        })

        if vim.bo.filetype == "org" then
            set_org_keymaps(vim.api.nvim_get_current_buf())
        end

        -- Enable built-in LSP capabilities for Org.
        vim.lsp.enable "org"
    end,
}
