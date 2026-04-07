vim.pack.add({ 'https://github.com/kazhala/close-buffers.nvim' }, { confirm = false })

local function delete_other_buffers(force)
	if not force then
		pcall(function(cmd) vim.cmd(cmd) end, 'BDelete other')
	else
		vim.cmd('BDelete! other')
	end
	vim.cmd('redraw!')
end

vim.keymap.set('n', '<leader>b', function() delete_other_buffers(false) end, { desc = 'Delete other buffers' })
vim.keymap.set('n', '<leader>B', function() delete_other_buffers(true) end, { desc = 'Force delete other buffers' })
