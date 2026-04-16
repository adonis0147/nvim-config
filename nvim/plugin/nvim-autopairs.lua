vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' }, { confirm = false })

local npairs = require('nvim-autopairs')
npairs.setup {
	check_ts = true,
	disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'dap-repl' },
}

local cond = require('nvim-autopairs.conds')
local quote = require('nvim-autopairs.rules.basic').quote_creator(npairs.config)

npairs.remove_rule('"')
npairs.add_rule(quote('"', '"', { '-vim', '-sh', '-zsh' }))
npairs.add_rule(quote('"', '"', 'vim'):with_pair(cond.not_before_regex('^%s*$', -1)))
