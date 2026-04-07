--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

-- Use a space as the leader key
vim.g.mapleader = ' '

-- Disable highlight
vim.keymap.set('n', '<leader><cr>', '<cmd>nohl<cr>')

-- Quick quit command
vim.keymap.set('n', '<leader>e', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader>E', '<cmd>qa!<cr>')

-- Easier moving between windows
vim.keymap.set('', '<c-h>', '<c-w>h')
vim.keymap.set('', '<c-j>', '<c-w>j')
vim.keymap.set('', '<c-k>', '<c-w>k')
vim.keymap.set('', '<c-l>', '<c-w>l')

-- Easier moving between tabs
vim.keymap.set({ 'n' }, '<leader>n', '<cmd>bprevious<cr>')
vim.keymap.set({ 'n' }, '<leader>m', '<cmd>bnext<cr>')

-- Easier moving of code blocks
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Spell checking
local function toggle_spell_checking()
	if not vim.wo.spell then
		vim.wo.spell = true
	else
		vim.wo.spell = false
	end
	print('Spell checking: ' .. (vim.wo.spell and 'on' or 'off'))
end

vim.keymap.set('n', '<leader>s', toggle_spell_checking)

--------------------------------------------------------------------------------
--                                  Autocmds                                  --
--------------------------------------------------------------------------------

-- Delete pack
local function get_pack_name()
	local parser = assert(vim.treesitter.get_parser(0, 'markdown'), 'Failed to get the parser for markdown')
	local tree = parser:parse()[1]
	local delta = nil
	local heading = nil
	local function find_heading_at_cursor(node, cursor_row)
		if node:type() == 'atx_heading' then
			local start_row, _ = node:range()
			if cursor_row >= start_row then
				if not delta or (cursor_row - start_row) < delta then
					delta = cursor_row - start_row
					local text = vim.treesitter.get_node_text(node, 0)
					heading = string.gsub(text, '^#+%s*([^ ]*)%s*.*', '%1', 1)
				end
			end
		end

		for child in node:iter_children() do
			find_heading_at_cursor(child, cursor_row)
		end
	end

	find_heading_at_cursor(tree:root(), vim.api.nvim_win_get_cursor(0)[1] - 1)
	return heading
end

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'nvim-pack',
	callback = function()
		vim.keymap.set('n', 'x', function()
			local pack_name = get_pack_name()
			print(pack_name)
			if pack_name then
				vim.notify('Delete pack: ' .. pack_name)
				vim.system({ 'nvim', '-u', 'NONE',
					'-c', 'lua vim.pack.del({\'' .. pack_name .. '\'})',
					'-c', 'qa!' }):wait()
			end
		end, { buffer = true })
	end
})

-- Build and run
local function save_and_run_cmd(cmd)
	local cmd_string = '<esc>:w<cr>'
	return cmd_string .. ':split term://' .. cmd .. ' <cr>'
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
	save_and_run_cmd(cxx .. ' -g -std=c++23 % -o $(dirname %:p)/%:t:r && $(dirname %:p)/%:t:r'))
vim.cmd('autocmd FileType cpp imap <F9> ' ..
	save_and_run_cmd(cxx .. ' -g -std=c++23 % -o $(dirname %:p)/%:t:r && $(dirname %:p)/%:t:r'))
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
