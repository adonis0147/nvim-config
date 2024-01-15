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

-- Build and run
local function save_and_run_cmd(cmd)
    local cmd_string = '<esc>:w<cr>'
    return cmd_string .. ':terminal ' .. cmd .. ' <cr>'
end

-- Make
vim.cmd('autocmd FileType c,cpp nmap <F5> ' .. save_and_run_cmd('make'))
vim.cmd('autocmd FileType c,cpp imap <F5> ' .. save_and_run_cmd('make'))

local cc = 'gcc'
local cxx = 'g++'
if vim.fn.has('macunix') == 1 then
    cc = 'clang'
    cxx = 'clang++'
end

vim.cmd('autocmd FileType c nmap <F9> ' ..
    save_and_run_cmd(cc .. ' -g % -o $(dirname %:p)/%:t:r && $(dirname %:p)/%:t:r'))
vim.cmd('autocmd FileType c imap <F9> ' ..
    save_and_run_cmd(cc .. ' -g % -o $(dirname %:p)/%:t:r && $(dirname %:p)/%:t:r'))
vim.cmd('autocmd FileType cpp nmap <F9> ' ..
    save_and_run_cmd(cxx .. ' -g -std=c++20 % -o $(dirname %:p)/%:t:r && $(dirname %:p)/%:t:r'))
vim.cmd('autocmd FileType cpp imap <F9> ' ..
    save_and_run_cmd(cxx .. ' -g -std=c++20 % -o $(dirname %:p)/%:t:r && $(dirname %:p)/%:t:r'))
vim.cmd('autocmd FileType rust nmap <F9> ' .. save_and_run_cmd('cargo run'))
vim.cmd('autocmd FileType rust imap <F9> ' .. save_and_run_cmd('cargo run'))
vim.cmd('autocmd FileType go nmap <F9> ' .. save_and_run_cmd('go run %'))
vim.cmd('autocmd FileType go imap <F9> ' .. save_and_run_cmd('go run %'))
vim.cmd('autocmd FileType python nmap <F9> ' .. save_and_run_cmd('python3 %'))
vim.cmd('autocmd FileType python imap <F9> ' .. save_and_run_cmd('python3 %'))
vim.cmd('autocmd FileType ruby nmap <F9> ' .. save_and_run_cmd('ruby %'))
vim.cmd('autocmd FileType ruby imap <F9> ' .. save_and_run_cmd('ruby %'))
vim.cmd('autocmd FileType sh nmap <F9> ' .. save_and_run_cmd('bash %'))
vim.cmd('autocmd FileType sh imap <F9> ' .. save_and_run_cmd('bash %'))
