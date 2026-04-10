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

-- UI 2
vim.opt.cmdheight = 0
require('vim._core.ui2').enable();
