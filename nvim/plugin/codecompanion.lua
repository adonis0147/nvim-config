vim.pack.add({ 'https://github.com/olimorris/codecompanion.nvim' }, { confirm = false })

require('codecompanion').setup({
	interactions = {
		cli = {
			agent = 'copilot',
			agents = {
				copilot = {
					cmd = 'copilot',
					args = {},
					description = 'GitHub Copilot CLI',
					provider = 'terminal',
				},
			},
		},
	},
	display = {
		chat = {
			window = {
				layout = 'vertical',
				position = 'right',
			},
		},
	},
	opts = {
		log_level = 'DEBUG',
	},
})
