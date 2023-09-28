vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()

-- ctrl + n opens find file toggle
vim.keymap.set('n', '<C-r>', ':NvimTreeFindFileToggle<CR>')
