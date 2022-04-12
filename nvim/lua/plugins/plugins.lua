--------------------------------------------------------------------------------
--                                  Plugins                                   --
--------------------------------------------------------------------------------

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'tanvirtin/monokai.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'noib3/nvim-bufferline'
    use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'ahmedkhalf/project.nvim'
    use 'phaazon/hop.nvim'
    use 'windwp/nvim-autopairs'
    use 'b3nj5m1n/kommentary'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-path'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'neovim/nvim-lspconfig'
    use 'nvim-treesitter/nvim-treesitter'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'junegunn/vim-easy-align'
    use 'azabiong/vim-highlighter'
    use 'axelf4/vim-strip-trailing-whitespace'
    use { 'mattn/emmet-vim', ft = { 'html', 'xml' } }
    use 'ludovicchabant/vim-gutentags'
end)

