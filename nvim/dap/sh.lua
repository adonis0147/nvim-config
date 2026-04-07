local dap = require('dap')

dap.adapters.bashdb = {
	type = 'executable',
	command = 'bash-debug-adapter',
	name = 'bashdb',
}

dap.configurations.sh = {
	{
		type = 'bashdb',
		request = 'launch',
		name = 'Launch file',
		showDebugOutput = true,
		pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
		pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
		trace = true,
		file = '${file}',
		program = '${file}',
		cwd = '${workspaceFolder}',
		pathCat = 'cat',
		pathBash = 'bash',
		pathMkfifo = 'mkfifo',
		pathPkill = 'pkill',
		args = {}, -- Prefer this to argsString
		argsString = '',
		env = {},
		terminalKind = 'integrated',
	}
}
