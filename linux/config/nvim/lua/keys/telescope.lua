local builtin = require "telescope.builtin"
local root_dir = require "utils.root_dir"

vim.keymap.set("n", "<leader>ff", function()
    builtin.find_files { cwd = root_dir.current_project() }
end, { desc = "Find project files" })

vim.keymap.set("n", "<leader>fg", function()
    builtin.live_grep { cwd = root_dir.current_project() }
end, { desc = "Grep project" })

vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find LSP references" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })

vim.keymap.set("n", "<leader>fe", function()
    local root = root_dir.current_project()
    require("telescope").extensions.file_browser.file_browser {
        path = root,
        cwd = root,
        select_buffer = true,
    }
end, { desc = "Browse project files" })
