--------------------------------------------------------------------------------
--                                  Plugins                                   --
--------------------------------------------------------------------------------

-- Runtime path
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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
    'nvim-lua/plenary.nvim',
    { 'tanvirtin/monokai.nvim',     config = settings.setup_monokai_nvim },
    {
        'nvim-lualine/lualine.nvim',
        config = settings.setup_lualine_nvim,
        event = 'BufEnter'
    },
    { 'willothy/nvim-cokeline',     config = settings.setup_nvim_cokeline },
    { 'kazhala/close-buffers.nvim', config = settings.setup_close_buffers_nvim },
    { 'folke/flash.nvim',           config = settings.setup_flash_nvim,        event = 'VeryLazy' },
    { 'folke/ts-comments.nvim',     opts = {},                                 event = 'VeryLazy' },
    {
        'windwp/nvim-autopairs',
        config = settings.setup_nvim_autopairs,
        event = 'InsertEnter'
    },
    {
        'nvim-focus/focus.nvim',
        config = settings.setup_focus_nvim,
        cond = 'not vim.o.diff',
        event = 'BufNew'
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-live-grep-args.nvim',
            { 'stevearc/aerial.nvim',                     config = settings.setup_aerial_nvim },
        },
        config = settings.setup_telescope_nvim,
        keys = { '<leader>ff', '<leader>fg', '<leader>fb', '<leader>fh', '<leader>fw', '<leader>fa' },
    },
    { 'ahmedkhalf/project.nvim',         config = settings.setup_project_nvim },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'saadparwaiz1/cmp_luasnip',    dependencies = 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'rafamadriz/friendly-snippets' },
        },
        config = settings.setup_nvim_cmp,
        event = { 'InsertEnter', 'CmdlineEnter' },
    },
    {
        'williamboman/mason.nvim',
        dependencies = {
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = settings.setup_lsp,
    },
    { 'jose-elias-alvarez/null-ls.nvim', config = settings.setup_null_ls_nvim },
    { 'mrcjkb/rustaceanvim',             version = '^4',                            ft = { 'rust' } },
    { 'nvim-treesitter/nvim-treesitter', config = settings.setup_nvim_treesitter },
    { 'ten3roberts/qf.nvim',             config = settings.setup_qf_nvim },
    { 'norcalli/nvim-colorizer.lua',     config = settings.setup_nvim_colorizer_lua },
    { 'sindrets/diffview.nvim',          config = settings.setup_diffview_nvim },
    { 'NMAC427/guess-indent.nvim',       config = settings.setup_guess_indent_nvim },
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'azabiong/vim-highlighter',
    { 'junegunn/vim-easy-align',             config = key_bindings.setup_vim_easy_align_keymaps },
    { 'mattn/emmet-vim',                     ft = { 'html', 'xml' } },
    { 'segeljakt/vim-silicon',               config = settings.setup_vim_silicon },
    { 'axelf4/vim-strip-trailing-whitespace' },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = { 'tanvirtin/monokai.nvim', 'nvim-neotest/nvim-nio' },
                config = settings.setup_nvim_dap_ui
            },
            { 'theHamsta/nvim-dap-virtual-text', config = settings.setup_nvim_dap_virtual_text }
        },
        config = settings.setup_dap
    },
    { 'LiadOz/nvim-dap-repl-highlights', config = true },
}
