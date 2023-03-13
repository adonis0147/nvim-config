--------------------------------------------------------------------------------
--                                  Plugins                                   --
--------------------------------------------------------------------------------

local settings = require('plugins.settings')
local key_bindings = require('plugins.key_bindings')

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use { 'tanvirtin/monokai.nvim', config = settings.setup_monokai_nvim }
    use {
        'nvim-lualine/lualine.nvim', config = settings.setup_lualine_nvim,
        opt = true, event = 'BufEnter'
    }
    use { 'noib3/nvim-bufferline', config = settings.setup_nvim_bufferline }
    use { 'kazhala/close-buffers.nvim', config = settings.setup_close_buffers_nvim }
    use { 'phaazon/hop.nvim', config = settings.setup_hop_nvim, after = 'monokai.nvim' }
    use { 'altermo/ultimate-autopair.nvim', config = settings.setup_ultimate_autopair_nvim,
        opt = true, event = { 'InsertEnter', 'CmdlineEnter' }
    }
    use {
        'b3nj5m1n/kommentary', config = settings.setup_kommentary,
        opt = true, keys = '<leader>cc'
    }
    use {
        'beauwilliams/focus.nvim', config = settings.setup_focus_nvim,
        opt = true, cond = 'not vim.o.diff', event = 'BufNew'
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            'nvim-telescope/telescope-live-grep-args.nvim',
        },
        config = settings.setup_telescope_nvim,
        opt = true,
        keys = { '<leader>ff', '<leader>fg', '<leader>fb', '<leader>fh', '<leader>fw' },
    }
    use { 'ahmedkhalf/project.nvim', config = settings.setup_project_nvim }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'saadparwaiz1/cmp_luasnip', requires = 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
        },
        config = settings.setup_nvim_cmp,
        opt = true,
        event = { 'InsertEnter', 'CmdlineEnter' },
    }
    use { 'rafamadriz/friendly-snippets', opt = true }
    use {
        'williamboman/mason.nvim',
        requires = {
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = settings.setup_lsp,
    }
    use { 'jose-elias-alvarez/null-ls.nvim', config = settings.setup_null_ls_nvim }
    use { 'nvim-treesitter/nvim-treesitter', config = settings.setup_nvim_treesitter }
    use { 'ojroques/nvim-osc52', config = settings.setup_nvim_osc52 }
    use { 'lewis6991/spellsitter.nvim', config = settings.setup_spellsitter_nvim }
    use { 'ten3roberts/qf.nvim', config = settings.setup_qf_nvim }
    use { 'norcalli/nvim-colorizer.lua', config = settings.setup_nvim_colorizer_lua, ft = { 'yaml' } }
    use { 'sindrets/diffview.nvim', config = settings.setup_diffview_nvim }
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'azabiong/vim-highlighter'
    use { 'junegunn/vim-easy-align', config = key_bindings.setup_vim_easy_align_keymaps }
    use { 'mattn/emmet-vim', ft = { 'html', 'xml' } }
    use { 'segeljakt/vim-silicon', config = settings.setup_vim_silicon }
end)
