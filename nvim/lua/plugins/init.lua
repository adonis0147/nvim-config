require('plugins.plugins')

local function configure_plugins()
    require('plugins.settings')
    require('plugins.key_bindings')
end

local ok, error = pcall(configure_plugins)
if not ok then
    vim.api.nvim_command('colorscheme desert')
    print('Errors occurred when configuring plugins. [ERROR] ' .. error)
end

-- Highlights
vim.api.nvim_command('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold')
