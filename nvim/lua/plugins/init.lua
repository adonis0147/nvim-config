require('plugins.plugins')

local configure_plugins = function()
    require('plugins.settings')
    require('plugins.key_bindings')
end

configure_plugins()

-- Highlights
vim.api.nvim_command('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold')

