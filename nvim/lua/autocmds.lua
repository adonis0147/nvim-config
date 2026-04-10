--------------------------------------------------------------------------------
--                                  Autocmds                                  --
--------------------------------------------------------------------------------

-- Termnial
local function setup_terminal()
	vim.opt_local.number = false
	vim.opt_local.spell = false
	vim.cmd('startinsert')
end

vim.api.nvim_create_autocmd('TermOpen', { pattern = '*', callback = setup_terminal })
vim.api.nvim_create_autocmd('TermEnter', { pattern = '*', callback = setup_terminal })
