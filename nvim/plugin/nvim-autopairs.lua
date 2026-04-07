vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' }, { confirm = false })

local npairs = require('nvim-autopairs')
npairs.setup {
	check_ts = true,
	disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'dap-repl' },
}
