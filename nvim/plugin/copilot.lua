vim.pack.add({ 'https://github.com/zbirenbaum/copilot.lua' }, { confirm = false })

--- @diagnostic disable-next-line: unused-local, unused-function
local function nvm_lts_node()
	local nvm = vim.fn.expand('~/.nvm')
	if vim.fn.isdirectory(nvm) == 0 then return end

	local alias = vim.fn.readfile(nvm .. '/alias/lts/*')[1]
	local version = vim.fn.readfile(nvm .. '/alias/' .. alias)[1]
	local node = nvm .. '/versions/node/' .. version .. '/bin/node'

	return vim.fn.executable(node) == 1 and node or nil
end

require('copilot').setup {
	copilot_node_command = nil,
	suggestion = {
		auto_trigger = true,
	}
}
