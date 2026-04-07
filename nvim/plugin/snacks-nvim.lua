vim.pack.add({ 'https://github.com/folke/snacks.nvim' }, { confirm = false })

require('snacks').setup()

local root_markers = {
	'.git',
	'.svn',
	'.hg',
	'Cargo.toml',
	'Makefile',
	'go.mod',
	'package.json',
	'pom.xml',
	'pyproject.toml',
}

local function get_root()
	return vim.fs.root(0, root_markers) or vim.fn.getcwd()
end

vim.keymap.set('n', '<leader>ff', function()
	require('snacks').picker.files({ cwd = get_root() })
end, { desc = 'Snacks Find files (project root)' })

vim.keymap.set('n', '<leader>fb', function() require('snacks').picker.buffers() end, { desc = 'Snacks Buffers' })
vim.keymap.set('n', '<leader>fg', function() require('snacks').picker.git_files() end, { desc = 'Snacks Git Files' })
vim.keymap.set('n', '<leader>fc', function() require('snacks').picker.files({ cwd = vim.fn.stdpath('config') }) end,
	{ desc = 'Snacks Find Config File' })
vim.keymap.set('n', '<leader>fs', function() require('snacks').picker.lsp_symbols() end, { desc = 'Snacks LSP Symbols' })

vim.keymap.set('n', '<leader>sg', function()
	require('snacks').picker.grep({ cwd = get_root() })
end, { desc = 'Snacks Grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function()
	require('snacks').picker.grep_word({ cwd = get_root() })
end, { desc = 'Snacks Visual Selection or Word' })

local function get_dap_configurations()
	local dap = require('dap')
	local file_type = vim.bo.filetype
	local configs = {}
	local lang_configs = dap.configurations[file_type]
	if lang_configs then
		for _, cfg in ipairs(lang_configs) do
			table.insert(configs, {
				name = cfg.name or '(unnamed)',
				type = cfg.type or '(unknown)',
				config = cfg,
			})
		end
	end
	return configs
end

vim.keymap.set('n', '<leader>fd', function()
	local configs = get_dap_configurations()
	require('snacks').picker({
		prompt = 'DAP Configurations',
		items = vim.tbl_map(function(cfg)
			return {
				text = string.format('%s [%s]', cfg.name, cfg.type),
				config = cfg.config,
			}
		end, configs),
		format = function(item)
			return { { item.text } }
		end,
		preview = function(context)
			local item = context.item
			if not item or not item.config then return end
			local value = vim.inspect(item.config)
			context.preview:set_lines(vim.split(value, '\n'))
		end,
		confirm = function(picker, item)
			picker:close()
			if item then
				require('dap').run(item.config)
			end
		end,
	})
end, { desc = 'Snacks DAP Configurations' })
