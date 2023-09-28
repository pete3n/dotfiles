    local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
    end

    local packer_bootstrap = ensure_packer()

    return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- Nerd tree file browser 
    use 'nvim-tree/nvim-tree.lua'
    -- Lua line highlighter
    use 'nvim-lualine/lualine.nvim'
    -- Treesitter 
    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('nvim-treesitter/playground')
    -- Telescope fuzzy searcher
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        requires = { {'nvim-lua/plenary.nvim'} }
    }  
    -- LSP plugins
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
            pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
        }
    }
    -- File browsing
    use 'stevearc/oil.nvim'

    -- File switching
    use('theprimeagen/harpoon')
    -- Color scheme
    use('folke/tokyonight.nvim')
    -- Undo tree
    use ('mbbill/undotree')
    -- vim-fugitive Git integration
    use ('tpope/vim-fugitive')
    -- AI plugins 
    use({
    "jackMort/ChatGPT.nvim",
        config = function()
        require("chatgpt").setup()
        end,
        requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
        }
    })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
