vim.pack.add({ 'https://github.com/junegunn/vim-easy-align' }, { confirm = false })

vim.keymap.set('x', '<enter>', '<plug>(EasyAlign)', {})
vim.keymap.set('n', 'ga', '<plug>(EasyAlign)', {})
