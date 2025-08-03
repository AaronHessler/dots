vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitright = true

vim.opt.wrap = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- 0 means use tabstop

vim.opt.clipboard = "unnamed"

vim.opt.scrolloff = 999

vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.diagnostic.config({
    virtual_lines = true,
})

vim.opt.conceallevel = 1
