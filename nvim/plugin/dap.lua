vim.pack.add({
	'https://github.com/mfussenegger/nvim-dap',
	'https://github.com/rcarriga/nvim-dap-ui',
	'https://github.com/theHamsta/nvim-dap-virtual-text',
}, { confirm = false })

require('dapui').setup()
require('nvim-dap-virtual-text').setup()

local function setup_appearance()
	local signs = {
		Breakpoint          = '',
		BreakpointCondition = '',
		LogPoint            = '',
		Stopped             = '',
		BreakpointRejected  = '',
	}
	for type, icon in pairs(signs) do
		local highlight = 'Dap' .. type
		local config = { text = icon, texthl = highlight }
		if type == 'Stopped' then
			config.linehl = highlight .. 'Line'
			config.numhl = highlight .. 'Line'
		end
		vim.fn.sign_define(highlight, config)
	end

	vim.api.nvim_create_autocmd('ColorScheme', {
		pattern = '*',
		desc = 'Prevent colorscheme clearing self-defined DAP marker colors',
		callback = function()
			-- Reuse current SignColumn background (except for DapStoppedLine)
			local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
			-- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
			-- convert to 6 digit hex value starting with #
			local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
			---@diagnostic disable-next-line: undefined-field
			local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

			vim.api.nvim_set_hl(0, 'DapBreakpoint',
				{ fg = '#e95678', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
			vim.api.nvim_set_hl(0, 'DapBreakpointCondition',
				{ fg = '#e6db74', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
			vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#66d9ef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
			vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#a6e22e', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
			vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#3d5213', ctermbg = 'Green' })
			vim.api.nvim_set_hl(0, 'DapBreakpointRejected',
				{ fg = '#8F908A', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
		end
	})

	-- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
	vim.cmd.colorscheme(vim.g.colors_name)

	-- Setup DAP UI
	local dap, dapui = require('dap'), require('dapui')
	dap.listeners.after.event_initialized['dapui_config'] = function()
		require('focus').setup({ autoresize = { enable = false }, ui = { signcolumn = false } })
		dapui.open()
	end
	dap.listeners.before.event_terminated['dapui_config'] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited['dapui_config'] = function()
		dapui.close()
		require('focus').setup({ autoresize = { enable = true }, ui = { signcolumn = true } })
	end
end

local function setup_dap_key_bindings()
	vim.keymap.set('n', '<m-r>', function() require('dap').run_to_cursor() end)
	vim.keymap.set('n', '<m-k>', function() require('dap').continue() end)
	vim.keymap.set('n', '<m-j>', function() require('dap').step_over() end)
	vim.keymap.set('n', '<m-l>', function() require('dap').step_into() end)
	vim.keymap.set('n', '<m-h>', function() require('dap').step_out() end)
	vim.keymap.set('n', '<m-b>', function() require('dap').toggle_breakpoint() end)
	vim.keymap.set('n', '<m-B>', function() require('dap').set_breakpoint() end)
	vim.keymap.set('n', '<m-p>',
		function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
	vim.keymap.set('n', '<m-c>', function() require('dap').set_breakpoint(vim.fn.input('Condition: '), nil, nil) end)
	vim.keymap.set('n', '<m-d>', function() require('dapui').eval() end)
	vim.keymap.set('n', '<m-f>',
		function() require('dapui').eval(vim.fn.input('Expression: '), { context = 'watch' }) end)
	vim.keymap.set('n', '<m-o>',
		function() require('dapui').open({ reset = true }) end)
end

setup_appearance()
setup_dap_key_bindings()

local dap_path = vim.fn.stdpath('config') .. '/dap'
local dap_configs = vim.fn.readdir(dap_path)
for _, config in ipairs(dap_configs) do
	vim.cmd('luafile ' .. dap_path .. '/' .. config)
end

local function merge_custom_dap_configs(type_to_filetypes)
	local dap = require('dap')
	local custom_configs = require('dap.ext.vscode').getconfigs()
	assert(custom_configs, 'launch.json must have a "configurations" key')

	for _, config in ipairs(custom_configs) do
		assert(config.type, 'Configuration in launch.json must have a "type" key')
		assert(config.name, 'Configuration in launch.json must have a "name" key')

		local filetypes = type_to_filetypes[config.type] or { config.type }
		for _, filetype in pairs(filetypes) do
			local dap_configurations = dap.configurations[filetype] or {}
			local merge = false
			for i, dap_config in pairs(dap_configurations) do
				if dap_config.name == config.name then
					dap_configurations[i] = vim.tbl_extend('force', dap_config, config)
					merge = true
				end
			end
			if not merge then
				table.insert(dap_configurations, config)
			end
		end
	end
end

merge_custom_dap_configs {
	cppdbg = { 'cpp', 'c' },
	lldb   = { 'cpp', 'c' },
	bashdb = { 'sh' },
}
