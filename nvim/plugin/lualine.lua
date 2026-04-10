vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' }, { confirm = false })

require('lualine').setup {
	options = {
		theme = 'powerline',
	},
	sections = {
		lualine_x = {
			{ 'encoding', 'fileformat', 'filetype' }
		}
	},
}
