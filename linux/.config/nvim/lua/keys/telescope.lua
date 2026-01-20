local builtin = require "telescope.builtin"

-- Find file (from nvim launch dir)
vim.keymap.set("n", "<leader>ff", builtin.find_files, { noremap = true, silent = true })

-- Grep (from nvim launch dir)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { noremap = true, silent = true })

-- Show buffers
vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true, silent = true })

-- Find references
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { noremap = true, silent = true })

-- Help tags
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true, silent = true })

-- Create a new file
vim.keymap.set("n", "<leader>fe", function()
    require("telescope").extensions.file_browser.file_browser {
        path = vim.fn.getcwd(), -- Nvim launch path
        select_buffer = true,
    }
end, { noremap = true, silent = true, desc = "Telescope File Explorer" })
