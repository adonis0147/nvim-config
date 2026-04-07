local dap = require('dap')

dap.adapters.cppdbg = {
	id = 'cppdbg',
	type = 'executable',
	command = 'OpenDebugAD7',
}

dap.adapters.lldb = {
	name = 'lldb',
	type = 'executable',
	command = vim.fn.exepath('lldb-dap')
}

dap.configurations.cpp = {
	{
		name = 'Launch file',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = {},
	},
}

local cpp_config
if vim.fn.executable('OpenDebugAD7') == 1 then
	cpp_config = {
		type = 'cppdbg',
		setupCommands = {
			{
				text = '-enable-pretty-printing',
				description = 'enable pretty printing',
				ignoreFailures = false
			},
		},
	}
else
	cpp_config = {
		type = 'lldb',
		runInTerminal = true,
	}
end

for index, dap_configuration in ipairs(dap.configurations.cpp) do
	dap.configurations.cpp[index] = vim.tbl_extend('force', dap_configuration, cpp_config)
end

dap.configurations.c = dap.configurations.cpp
