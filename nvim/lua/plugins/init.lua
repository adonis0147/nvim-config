require('plugins.plugins')

local configure_plugins = function()
    require('plugins.settings')
    require('plugins.key_bindings')
    return true
end

if not pcall(configure_plugins) then
    vim.api.nvim_command('syntax off')
    vim.cmd('echomsg "Errors occurred when configuring plugins."')
end

-- Highlights
vim.api.nvim_command('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold')

