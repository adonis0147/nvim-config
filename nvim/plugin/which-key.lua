vim.pack.add({ 'https://github.com/folke/which-key.nvim' }, { confirm = false })

vim.keymap.set({ 'n' }, '<leader>?', function()
	require('which-key').show({ global = false })
end, { desc = 'Flash' })
