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
    {
        'phaazon/hop.nvim',
        config = settings.setup_hop_nvim,
        dependencies = { 'tanvirtin/monokai.nvim' }
    },
    {
        'windwp/nvim-autopairs',
        config = settings.setup_nvim_autopairs,
        event = "InsertEnter"
    },
    {
        'b3nj5m1n/kommentary',
        config = settings.setup_kommentary,
        keys = { { '<leader>cc', mode = { 'n', 'x' } } }
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
        },
        config = settings.setup_telescope_nvim,
        keys = { '<leader>ff', '<leader>fg', '<leader>fb', '<leader>fh', '<leader>fw' },
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
    { 'hedyhli/outline.nvim',
        cmd = { "Outline", "OutlineOpen" },
        keys = {
            { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        config = settings.setup_outline_nvim
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^3', -- Recommended
        ft = { 'rust' },
    },
    { 'nvim-treesitter/nvim-treesitter', config = settings.setup_nvim_treesitter },
    { 'ojroques/nvim-osc52',             config = settings.setup_nvim_osc52 },
    { 'ten3roberts/qf.nvim',             config = settings.setup_qf_nvim },
    { 'norcalli/nvim-colorizer.lua',     config = settings.setup_nvim_colorizer_lua },
    { 'sindrets/diffview.nvim',          config = settings.setup_diffview_nvim },
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'azabiong/vim-highlighter',
    { 'junegunn/vim-easy-align',        config = key_bindings.setup_vim_easy_align_keymaps },
    { 'mattn/emmet-vim',                ft = { 'html', 'xml' } },
    { 'segeljakt/vim-silicon',          config = settings.setup_vim_silicon },
    { 'thirtythreeforty/lessspace.vim', config = settings.setup_lessspace_vim },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = { 'tanvirtin/monokai.nvim' },
                config = settings.setup_nvim_dap_ui
            },
            { 'theHamsta/nvim-dap-virtual-text', config = settings.setup_nvim_dap_virtual_text }
        },
        config = settings.setup_dap
    },
    { 'LiadOz/nvim-dap-repl-highlights', config = true },
}
