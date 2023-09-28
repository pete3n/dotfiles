-- use space as the leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.relativenumber = true

-- backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true


-- colors
vim.opt.termguicolors = true 
vim.opt.colorcolumn = "80"

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.cursorline = true

-- spaces and tabs
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- scrolling
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

