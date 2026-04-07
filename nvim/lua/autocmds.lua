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

-- Pack commands
vim.api.nvim_create_user_command('PackUpdate', function()
	vim.pack.update()
end, { desc = 'Update all packs' })

vim.api.nvim_create_user_command('PackClean', function()
	local inactive_packs = vim.iter(vim.pack.get())
		:filter(function(pack)
			return not pack.active
		end)
		:map(function(pack)
			return pack.spec.name
		end)
		:totable()
	vim.pack.del(inactive_packs)
end, { desc = 'Clean all inactive packs' })
