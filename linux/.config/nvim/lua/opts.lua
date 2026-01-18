local opt = vim.opt

local shell = require("shell").shell
local bin_shell = "/bin/" .. shell

if vim.fn.filereadable(bin_shell) == 1 then
    opt.shell = bin_shell
elseif vim.fn.executable(shell) == 1 then
    opt.shell = vim.fn.exepath(shell)
else
    vim.notify("Warning: bash not found, falling to /bin/sh", vim.log.levels.WARN)
    opt.shell = "/bin/sh"
end

-- Value of tab as spaces when reading.
opt.tabstop = 4

-- Value of tab as spaces when writing.
opt.shiftwidth = 4

-- Convert tab to spaces.
opt.expandtab = true

-- Show whitespace.
opt.list = true

-- Use y,p clipboard, bundles well with vimium.
opt.clipboard = "unnamedplus"

-- Line number settings
opt.relativenumber = true
opt.number = true

-- Indentation settings
opt.autoindent = true
opt.smartindent = true
