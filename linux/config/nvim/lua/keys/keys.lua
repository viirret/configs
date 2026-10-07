-- Leader key
vim.g.mapleader = " "

local km = require "keys.map_key"

-- Paste from os clipboard
km.set("n", "<M-v>", '"+p', { desc = "Paste clipboard after cursor" })
km.set("n", "<M-V>", '"+P', { desc = "Paste clipboard before cursor" })

-- Disable arrow keys
km.set("", "<up>", "<nop>")
km.set("", "<down>", "<nop>")
km.set("", "<left>", "<nop>")
km.set("", "<right>", "<nop>")
