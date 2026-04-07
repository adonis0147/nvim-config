Utils.hook_pack_changed('blink.cmp', { 'install', 'update' }, function(ev)
	vim.notify('Building blink.cmp from source ...')
	vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
	vim.notify('blink.cmp built successfully.')
end)

vim.pack.add({
	'https://github.com/rafamadriz/friendly-snippets',
	{ src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') }
}, { confirm = false })

require('blink.cmp').setup {
	keymap = { preset = 'enter' },
	cmdline = {
		keymap = {
			['<tab>'] = { 'show', 'accept' },
			['<cr>'] = { 'select_accept_and_enter', 'fallback' }
		},
		completion = { menu = { auto_show = true } },
	},
	fuzzy = {
		prebuilt_binaries = {
			download = false
		}
	},
}
