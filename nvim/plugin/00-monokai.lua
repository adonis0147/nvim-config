vim.pack.add({ 'https://github.com/tanvirtin/monokai.nvim' }, { confirm = false })

require('monokai').setup { palette = require('monokai').pro }

vim.cmd('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold gui=bold')
