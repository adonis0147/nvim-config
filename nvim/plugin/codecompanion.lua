Utils.hook_pack_changed('mcphub.nvim', { 'install', 'update' }, function(ev)
	vim.system({ 'nvim', '--headless', '+luafile bundled_build.lua', '+qa' }, { cwd = ev.data.path }):wait()
end)

vim.pack.add({
	'https://github.com/ravitemer/mcphub.nvim',
	'https://github.com/olimorris/codecompanion.nvim',
}, { confirm = false })

require('mcphub').setup {
	use_bundled_binary = true
}

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
				opencode = {
					cmd = 'opencode',
					args = {},
					description = 'OpenCode CLI',
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
	extensions = {
		mcphub = {
			callback = 'mcphub.extensions.codecompanion',
			opts = {
				-- MCP Tools
				make_tools = true,        -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
				show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
				add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
				show_result_in_chat = true, -- Show tool results directly in chat buffer
				format_tool = nil,        -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
				-- MCP Resources
				make_vars = false,        -- Convert MCP resources to #variables for prompts
				-- MCP Prompts
				make_slash_commands = true, -- Add MCP prompts as /slash commands
			}
		}
	},
	opts = {
		log_level = 'DEBUG',
	},
})
