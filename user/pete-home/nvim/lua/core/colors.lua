local colors = {}

function colors.ColorPencils(color)
    color = color or "tokyonight-night"
    vim.cmd('colorscheme '..color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    
    -- Set line for vertically alignment highlighting
    vim.cmd('highlight CursorColumn cterm=reverse gui=reverse')
end

return colors
