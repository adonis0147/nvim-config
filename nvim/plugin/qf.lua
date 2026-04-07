vim.pack.add({ 'https://github.com/ten3roberts/qf.nvim' }, { confirm = false })

require('qf').setup {
	l = {
		max_height = 10,
		auto_resize = false,
	},
	c = {
		max_height = 10,
		auto_resize = false,
	},
}

for type, icon in pairs(Utils.get_diagnostic_icons()) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

local function qf_toggle(type)
	local ok, error = pcall(function() require('qf').toggle(type, true) end)
	if not ok then
		assert(error)
		vim.notify(string.match(error, 'E%d+:.*'), vim.log.levels.ERROR)
	end
end

local function close_qf_or_buffer()
	local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local is_quickfix = (win_info['quickfix'] == 1)
	local is_loclist = (win_info['loclist'] == 1)

	local ok, error = pcall(function()
		if is_quickfix then
			if not is_loclist then
				require('qf').toggle('c', true)
			else
				require('qf').toggle('l', true)
			end
		else
			vim.cmd('bdelete')
		end
	end)
	if not ok then
		assert(error)
		vim.notify(string.match(error, 'E%d+:.*'), vim.log.levels.ERROR)
	end
end

vim.keymap.set('n', '<leader>q', function() qf_toggle('c') end, { desc = 'Toggle quickfix list' })
vim.keymap.set('n', '<leader>l', function() qf_toggle('l') end, { desc = 'Toggle location list' })
vim.keymap.set('n', '<leader>e', close_qf_or_buffer, { desc = 'Close quickfix/location list or buffer' })
