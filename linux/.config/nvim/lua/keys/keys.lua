-- keys.lua
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Leader key
vim.g.mapleader = " "

-- Rename current file
vim.keymap.set("n", "<leader>m", function()
    -- Get current file path
    local current_file = vim.fn.expand "%:p"
    if current_file == "" then
        print "No file in buffer"
        return
    end

    -- Ask for new name
    local new_name = vim.fn.input("Rename to: ", current_file, "file")

    if new_name ~= "" and new_name ~= current_file then
        -- Rename the file
        vim.loop.fs_rename(current_file, new_name)

        -- Update the buffer
        vim.cmd("edit " .. vim.fn.fnameescape(new_name))
        vim.cmd "bd #" -- Remove old buffer

        print("Renamed: " .. current_file .. " -> " .. new_name)
    end
end, { noremap = true, silent = false, desc = "Rename current file" })

-- Paste from os clipboard
map("n", "<M-v>", '"+p')
map("n", "<M-V>", '"+P')

-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")
map("", "<right>", "<nop>")

--
-- Barbar
--

-- Ctrl j+k for swapping buffers.
map("n", "<C-j>", "<Cmd>BufferPrevious<CR>")
map("n", "<C-k>", "<Cmd>BufferNext<CR>")

-- Close buffer
map("n", "<C-x>", "<Cmd>BufferClose<CR>")

-- Re-order to previous/next
map("n", "<C-h>", "<Cmd>BufferMovePrevious<CR>")
map("n", "<C-l>", "<Cmd>BufferMoveNext<CR>")
