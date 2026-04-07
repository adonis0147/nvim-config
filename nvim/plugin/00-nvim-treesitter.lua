Utils.hook_pack_changed('nvim-treesitter', { 'install', 'update' }, function() vim.cmd('TSUpdate') end)

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' }, { confirm = false })

vim.api.nvim_create_autocmd('FileType', {
	callback = function()
		pcall(vim.treesitter.start)
		vim.bo.indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()'
	end,
})
