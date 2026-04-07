vim.pack.add({ 'https://github.com/folke/flash.nvim' }, { confirm = false })

require('flash').setup {
	modes = {
		char = {
			enabled = false
		}
	}
}

vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
