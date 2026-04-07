local dap = require('dap')

local python_exepath = function()
	local paths = {
		---@diagnostic disable-next-line: undefined-field
		vim.uv.os_homedir() .. '/.local/share/nvim/mason/packages/debugpy/venv/bin/python3',
		vim.fn.exepath('python3')
	}
	if os.getenv('VIRTUAL_ENV') ~= nil then
		table.insert(paths, 1, os.getenv('VIRTUAL_ENV') .. '/bin/python3')
	end

	for _, path in ipairs(paths) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end
end

dap.adapters.python = function(cb, config)
	if config.request == 'attach' then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or '127.0.0.1'
		cb({
			type = 'server',
			port = assert(port, '`connect.port` is required for a python `attach` configuration'),
			host = host,
			options = {
				source_filetype = 'python',
			},
		})
	else
		cb({
			type = 'executable',
			command = python_exepath(),
			args = { '-m', 'debugpy.adapter' },
			options = {
				source_filetype = 'python',
			},
		})
	end
end

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = 'launch',
		name = 'Launch file',

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
		program = '${file}', -- This configuration will launch the current file if used.
		console = 'integratedTerminal',
	},
}
