--------------------------------------------------------------------------------
--                                  Plugins                                   --
--------------------------------------------------------------------------------

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'tanvirtin/monokai.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'noib3/nvim-bufferline'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'nvim-telescope/telescope-live-grep-raw.nvim',
            'ahmedkhalf/project.nvim',
        }
    }
    use 'phaazon/hop.nvim'
    use 'windwp/nvim-autopairs'
    use 'b3nj5m1n/kommentary'
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp',
        }
    }
    use { 'saadparwaiz1/cmp_luasnip', requires = 'L3MON4D3/LuaSnip' }
    use 'rafamadriz/friendly-snippets'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'nvim-treesitter/nvim-treesitter'
    use 'beauwilliams/focus.nvim'
    use 'stevearc/qf_helper.nvim'
    use 'lewis6991/spellsitter.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'junegunn/vim-easy-align'
    use 'azabiong/vim-highlighter'
    use 'ojroques/vim-oscyank'
    use { 'mattn/emmet-vim', ft = { 'html', 'xml' } }
end)
