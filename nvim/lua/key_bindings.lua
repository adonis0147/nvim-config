--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

-- To toggle the paste mode
vim.opt.pastetoggle = '<F2>'

-- Use a space as the leader key
vim.g.mapleader = ' '

-- Disable highlight
vim.api.nvim_set_keymap('n', '<leader><cr>', '<cmd>nohl<cr>', { silent = true, noremap = true })

-- Quick quit command
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>bdelete<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>E', '<cmd>qa!<cr>', { noremap = true })

-- Easier moving between windows
vim.api.nvim_set_keymap('', '<c-h>', '<c-w>h', { noremap = true })
vim.api.nvim_set_keymap('', '<c-j>', '<c-w>j', { noremap = true })
vim.api.nvim_set_keymap('', '<c-k>', '<c-w>k', { noremap = true })
vim.api.nvim_set_keymap('', '<c-l>', '<c-w>l', { noremap = true })

-- Easier moving between tabs 
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>bprevious<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>bnext<cr>', { noremap = true })

-- Easier moving of code blocks
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

--------------------------------------------------------------------------------
--                                  Autocmd                                   --
--------------------------------------------------------------------------------

-- Make
vim.api.nvim_command('autocmd FileType c,cpp nmap <F5> :w<cr>:terminal make<cr>')
vim.api.nvim_command('autocmd FileType c,cpp imap <F5> <esc>:w<cr>:terminal make<cr>')

-- Build and run
vim.api.nvim_command('autocmd FileType c nmap <F9> :w<cr>:terminal gcc % -o %< && ./%< <cr>')
vim.api.nvim_command('autocmd FileType c imap <F9> <esc>:w<cr>:terminal gcc % -o %< && ./%< <cr>')
vim.api.nvim_command('autocmd FileType cpp nmap <F9> :w<cr>:terminal g++ -std=c++20 % -o %< && ./%< <cr>')
vim.api.nvim_command('autocmd FileType cpp imap <F9> <esc>:w<cr>:terminal g++ -std=c++20 % -o %< && ./%< <cr>')
vim.api.nvim_command('autocmd FileType go nmap <F9> :w<cr>:terminal go run %<cr>')
vim.api.nvim_command('autocmd FileType go imap <F9> <esc>:w<cr>:terminal go run %<cr>')
vim.api.nvim_command('autocmd FileType python nmap <F9> :w<cr>:terminal python %<cr>')
vim.api.nvim_command('autocmd FileType python imap <F9> <esc>:w<cr>:terminal python %<cr>')
vim.api.nvim_command('autocmd FileType ruby nmap <F9> :w<cr>:terminal ruby %<cr>')
vim.api.nvim_command('autocmd FileType ruby imap <F9> <esc>:w<cr>:terminal ruby %<cr>')
vim.api.nvim_command('autocmd FileType sh nmap <F9> :w<cr>:terminal bash %<cr>')
vim.api.nvim_command('autocmd FileType sh imap <F9> <esc>:w<cr>:terminal bash %<cr>')

