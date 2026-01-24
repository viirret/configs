local km = require "keys.map_key"

-- Ctrl j+k for swapping buffers.
km.set("n", "<C-j>", "<Cmd>BufferPrevious<CR>")
km.set("n", "<C-k>", "<Cmd>BufferNext<CR>")

-- Close buffer
km.set("n", "<C-x>", "<Cmd>BufferClose<CR>")

-- Re-order to previous/next
km.set("n", "<C-h>", "<Cmd>BufferMovePrevious<CR>")
km.set("n", "<C-l>", "<Cmd>BufferMoveNext<CR>")
