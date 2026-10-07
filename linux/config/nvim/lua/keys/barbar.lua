local km = require "keys.map_key"

-- Ctrl j+k for swapping buffers.
km.set("n", "<C-j>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
km.set("n", "<C-k>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })

-- Close buffer
km.set("n", "<C-x>", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })

-- Re-order to previous/next
km.set("n", "<C-h>", "<Cmd>BufferMovePrevious<CR>", { desc = "Move buffer left" })
km.set("n", "<C-l>", "<Cmd>BufferMoveNext<CR>", { desc = "Move buffer right" })
