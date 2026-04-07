vim.pack.add({
	'https://github.com/MunifTanjim/nui.nvim',
	'https://github.com/rcarriga/nvim-notify',
	'https://github.com/folke/noice.nvim',
}, { confirm = false })

require('noice').setup {
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
}

vim.schedule(function()
	vim.api.nvim_set_hl(0, 'NoiceVirtualText', { link = 'NonText' })
end)
