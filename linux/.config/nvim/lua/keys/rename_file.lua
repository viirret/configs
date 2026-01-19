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
