--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

-- To toggle the paste mode
vim.opt.pastetoggle = '<F2>'

-- Use a space as the leader key
vim.g.mapleader = ' '

-- Disable highlight
vim.keymap.set('n', '<leader><cr>', '<cmd>nohl<cr>', { silent = true, noremap = true })

-- Quick quit command
vim.keymap.set('n', '<leader>e', '<cmd>bdelete<cr>', { noremap = true })
vim.keymap.set('n', '<leader>E', '<cmd>qa!<cr>', { noremap = true })

-- Easier moving between windows
vim.keymap.set('', '<c-h>', '<c-w>h', { noremap = true })
vim.keymap.set('', '<c-j>', '<c-w>j', { noremap = true })
vim.keymap.set('', '<c-k>', '<c-w>k', { noremap = true })
vim.keymap.set('', '<c-l>', '<c-w>l', { noremap = true })

-- Easier moving between tabs
vim.keymap.set({ 'n', 't' }, '<leader>n', '<cmd>bprevious<cr>', { noremap = true })
vim.keymap.set({ 'n', 't' }, '<leader>m', '<cmd>bnext<cr>', { noremap = true })

-- Easier moving of code blocks
vim.keymap.set('x', '<', '<gv', { noremap = true })
vim.keymap.set('x', '>', '>gv', { noremap = true })

-- Spell checking
vim.keymap.set('n', '<leader>s', require('functions').toggle_spell_checking, { noremap = true })

--------------------------------------------------------------------------------
--                                  Autocmds                                  --
--------------------------------------------------------------------------------

-- Make
vim.cmd('autocmd FileType c,cpp nmap <F5> :w<cr>:terminal make<cr>')
vim.cmd('autocmd FileType c,cpp imap <F5> <esc>:w<cr>:terminal make<cr>')

-- Build and run
vim.cmd('autocmd FileType c nmap <F9> :w<cr>:terminal gcc % -o %< && ./%< <cr>')
vim.cmd('autocmd FileType c imap <F9> <esc>:w<cr>:terminal gcc % -o %< && ./%< <cr>')
vim.cmd('autocmd FileType cpp nmap <F9> :w<cr>:terminal g++ -std=c++20 % -o %< && ./%< <cr>')
vim.cmd('autocmd FileType cpp imap <F9> <esc>:w<cr>:terminal g++ -std=c++20 % -o %< && ./%< <cr>')
vim.cmd('autocmd FileType go nmap <F9> :w<cr>:terminal go run %<cr>')
vim.cmd('autocmd FileType go imap <F9> <esc>:w<cr>:terminal go run %<cr>')
vim.cmd('autocmd FileType python nmap <F9> :w<cr>:terminal python %<cr>')
vim.cmd('autocmd FileType python imap <F9> <esc>:w<cr>:terminal python %<cr>')
vim.cmd('autocmd FileType ruby nmap <F9> :w<cr>:terminal ruby %<cr>')
vim.cmd('autocmd FileType ruby imap <F9> <esc>:w<cr>:terminal ruby %<cr>')
vim.cmd('autocmd FileType sh nmap <F9> :w<cr>:terminal bash %<cr>')
vim.cmd('autocmd FileType sh imap <F9> <esc>:w<cr>:terminal bash %<cr>')
