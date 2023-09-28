local builtin = require('telescope.builtin')
local awesome_hotkey_gen = require('core.awesome_hotkey_gen')
local awesome_hk_name = "Telescope"
local desc_format = awesome_hk_name .. ": %s"

vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = string.format(desc_format, 'File search') })
vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, { desc = string.format(desc_format, 'Recent files') })
vim.keymap.set('n', '<Space>fg', builtin.live_grep, { desc = string.format(desc_format, 'Live grep') })
vim.keymap.set('n', '<Space>fh', builtin.help_tags, { desc = string.format(desc_format, 'Help tags') })
vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = string.format(desc_format, 'Git files') })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = string.format(desc_format, 'Grep cmdline') })

local all_keymaps = vim.api.nvim_get_keymap('n')

local telescope_keymaps = {}
for _, map in ipairs(all_keymaps) do
    if string.match(map.desc or "", "^" .. awesome_hk_name) then
        table.insert(telescope_keymaps, map)
    end
end

awesome_hotkey_gen.generate(telescope_keymaps, awesome_hk_name)
