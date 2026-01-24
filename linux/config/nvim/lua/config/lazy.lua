local fs = require "utils.fs"

-- Lazy nvim bootstrapping
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not fs.safe_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup "config.plugins"
