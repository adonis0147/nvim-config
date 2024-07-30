--------------------------------------------------------------------------------
--                                  Plugins                                   --
--------------------------------------------------------------------------------

-- Runtime path
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


local settings = require('plugins.settings')
local key_bindings = require('plugins.key_bindings')

require('lazy').setup {
    { 'tanvirtin/monokai.nvim',
        config = settings.setup_monokai_nvim,
        lazy = false,
        priority = 1000
    },
    { 'nvim-lua/plenary.nvim',               lazy = true },
    { "nvim-tree/nvim-web-devicons",         lazy = true },
    { 'neovim/nvim-lspconfig',               lazy = true },
    { 'nvim-treesitter/nvim-treesitter',     config = settings.setup_nvim_treesitter,       event = 'VeryLazy' },
    { 'nvim-lualine/lualine.nvim',           config = settings.setup_lualine_nvim,          event = 'BufWinEnter' },
    { 'willothy/nvim-cokeline',              config = settings.setup_nvim_cokeline,         event = { 'BufAdd', 'TabNew' } },
    { 'kazhala/close-buffers.nvim',          config = settings.setup_close_buffers_nvim,    keys = { '<leader>b', '<leader>B' } },
    { 'ten3roberts/qf.nvim',                 config = settings.setup_qf_nvim,               event = 'VeryLazy' },
    { 'NMAC427/guess-indent.nvim',           config = settings.setup_guess_indent_nvim,     event = { 'BufNewFile', 'BufReadPost' } },
    { 'lukas-reineke/indent-blankline.nvim', config = settings.setup_indent_blankline_nvim, event = 'VeryLazy' },
    { 'folke/flash.nvim',                    config = settings.setup_flash_nvim,            event = 'VeryLazy' },
    { 'folke/ts-comments.nvim',              opts = {},                                     event = 'VeryLazy' },
    { 'windwp/nvim-autopairs',               config = settings.setup_nvim_autopairs,        event = 'InsertEnter' },
    { 'ahmedkhalf/project.nvim',             config = settings.setup_project_nvim,          event = 'VimEnter' },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-live-grep-args.nvim',
            { 'stevearc/aerial.nvim',                     config = settings.setup_aerial_nvim, keys = '<leader>a' },
        },
        config = settings.setup_telescope_nvim,
        keys = { '<leader>ff', '<leader>fg', '<leader>fb', '<leader>fh', '<leader>fw', '<leader>fa' },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'saadparwaiz1/cmp_luasnip', dependencies = { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' } },
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'rafamadriz/friendly-snippets',
        },
        config = settings.setup_nvim_cmp,
        event = { 'InsertEnter', 'CmdlineEnter' },
    },
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = settings.setup_lsp,
        event = { 'BufNewFile', 'BufReadPost' }
    },
    { 'mrcjkb/rustaceanvim',                  version = '^4',                                     ft = 'rust' },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = { { 'nvim-neotest/nvim-nio', lazy = true } },
                config = settings.setup_nvim_dap_ui,
            },
            { 'theHamsta/nvim-dap-virtual-text', config = settings.setup_nvim_dap_virtual_text }
        },
        config = settings.setup_dap,
        keys = { '<m-k>', '<m-b>', '<m-B>', '<m-p>', '<m-c>' },
    },
    { 'LiadOz/nvim-dap-repl-highlights',      config = true,                                      ft = 'dap-repl' },
    { 'norcalli/nvim-colorizer.lua',          config = settings.setup_nvim_colorizer_lua,         event = 'VeryLazy' },
    { 'nvim-focus/focus.nvim',                config = settings.setup_focus_nvim,                 event = 'VeryLazy' },
    { 'sindrets/diffview.nvim',               config = settings.setup_diffview_nvim,              event = 'VeryLazy' },

    -- Vim plugins
    { 'axelf4/vim-strip-trailing-whitespace', event = { 'BufNewFile', 'BufReadPost' } },
    { 'tpope/vim-surround',                   event = 'VeryLazy' },
    { 'tpope/vim-repeat',                     event = 'VeryLazy' },
    { 'mattn/emmet-vim',                      ft = { 'html', 'xml' } },
    { 'azabiong/vim-highlighter',             keys = 'f' },
    { 'junegunn/vim-easy-align',              config = key_bindings.setup_vim_easy_align_keymaps, keys = { { '<enter>', mode = 'x' }, 'ga' } },
    { 'segeljakt/vim-silicon',                config = settings.setup_vim_silicon,                event = 'CmdlineEnter' },
}
