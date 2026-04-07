vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' }, { confirm = false })

require('ibl').setup {
	indent = { char = '¦' },
	scope = { enabled = false },
}
