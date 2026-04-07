vim.pack.add({
	'https://github.com/willothy/nvim-cokeline'
}, { confirm = false })

local get_hex = require('cokeline.hlgroups').get_hl_attr

require('cokeline').setup {
	show_if_buffers_are_at_least = 2,
	default_hl = {
		fg = function(buffer)
			return buffer.is_focused and get_hex('ColorColumn', 'bg') or get_hex('Normal', 'fg')
		end,
		bg = function(buffer)
			return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('ColorColumn', 'bg')
		end,
	},
	components = {
		{
			text = function(buffer) return ' ' .. buffer.devicon.icon end,
			fg = function(buffer) return buffer.devicon.color end,
		},
		{
			text = function(buffer) return buffer.index .. ': ' .. buffer.filename .. ' ' end,
		},
		{
			text = function(buffer)
				return buffer.is_modified and '●' or '✘'
			end,
			fg = function(buffer)
				if buffer.is_modified then
					return 'Orange'
				elseif buffer.is_focused then
					return 'DarkGreen'
				else
					return 'LightGreen'
				end
			end,
			delete_buffer_on_left_click = true,
		},
		{
			text = ' '
		}
	},
}

for i = 1, 9 do
	vim.keymap.set('n', ('<m-%s>'):format(i), ('<Plug>(cokeline-focus-%s)'):format(i),
		{ silent = true, desc = ('cokeline-focus-%s>'):format(i) })
end
vim.keymap.set('n', '<leader>n', '<Plug>(cokeline-focus-prev)', { desc = 'cokeline-focus-prev' })
vim.keymap.set('n', '<leader>m', '<Plug>(cokeline-focus-next)', { desc = 'cokeline-focus-next' })
vim.keymap.set('n', '<leader>N', '<Plug>(cokeline-switch-prev)', { desc = 'cokeline-switch-prev' })
vim.keymap.set('n', '<leader>M', '<Plug>(cokeline-switch-next)', { desc = 'cokeline-switch-next' })
