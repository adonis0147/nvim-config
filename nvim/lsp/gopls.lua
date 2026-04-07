return {
	cmd_env = {
		GOFUMPT_SPLIT_LONG_LINES = 'on'
	},
	settings = {
		gopls = {
			gofumpt = true,
			['hints'] = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	}
}
