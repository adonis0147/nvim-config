require('plugins.plugins')

local function configure_plugins()
    require('plugins.settings')
    require('plugins.key_bindings')
end

if not pcall(configure_plugins) then
    vim.api.nvim_command('colorscheme desert')
    vim.cmd('echomsg "Errors occurred when configuring plugins."')
end

-- Highlights
vim.api.nvim_command('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold')
