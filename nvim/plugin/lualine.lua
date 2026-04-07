vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' }, { confirm = false })

local lualine_x = {}
if pcall(require, 'noice') then
	vim.list_extend(lualine_x, {
		{
			require('noice').api.status.search.get,
			cond = require('noice').api.status.search.has,
			color = { fg = '#ff9e64' },
		},
	})
end
lualine_x = vim.list_extend(lualine_x, { 'encoding', 'fileformat', 'filetype' })

require('lualine').setup {
	options = {
		theme = 'powerline',
	},
	sections = {
		lualine_x = lualine_x,
	},
}
