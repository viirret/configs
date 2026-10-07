local fs = require "utils.fs"

-- Lazy nvim bootstrapping
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not fs.safe_stat(lazypath) then
    if vim.fn.executable "git" == 0 then
        error "Cannot install lazy.nvim: git is missing from PATH. Install git and restart Neovim."
    end
    local output = vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
    if vim.v.shell_error ~= 0 then
        error(
            "Cannot install lazy.nvim at "
                .. lazypath
                .. ":\n"
                .. output
                .. "\nCheck network access and directory permissions, then restart Neovim."
        )
    end
end
if not fs.exists(lazypath .. "/lua/lazy/init.lua") then
    error(
        "Incomplete lazy.nvim installation at "
            .. lazypath
            .. ". Move that directory aside and restart Neovim to reinstall it."
    )
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup "config.plugins"
