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
    use "ahmedkhalf/project.nvim"
    use 'phaazon/hop.nvim'
    use 'windwp/nvim-autopairs'
    use 'b3nj5m1n/kommentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'junegunn/vim-easy-align'
    use 'azabiong/vim-highlighter'
    use 'axelf4/vim-strip-trailing-whitespace'
    use { 'mattn/emmet-vim', ft = { 'html', 'xml' } }
end)

require('plugins.settings')
require('plugins.key_bindings')

-- Highlights
vim.api.nvim_command('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold')

