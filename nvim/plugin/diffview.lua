vim.pack.add({ 'https://github.com/sindrets/diffview.nvim' }, { confirm = false })

require('diffview').setup {
	view = {
		merge_tool = {
			layout = 'diff4_mixed',
		},
	},
	hooks = {
		view_enter = function(_)
			require('focus').focus_disable()
		end,
		view_leave = function(_)
			require('focus').focus_disable()
		end,
		view_closed = function(_)
			require('focus').focus_enable()
		end
	}
}
