vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/williamboman/mason.nvim',
	'https://github.com/mason-org/mason-lspconfig.nvim',
}, { confirm = false })

local function on_attach(client, bufnr)
	-- :help lsp-method
	-- vim.lsp.protocol.Methods

	-- Format code on save.
	if client:supports_method('textDocument/formatting') then
		vim.cmd([[
			augroup LspFormatting
			autocmd! * <buffer>
			autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
			augroup END
		]])
	end

	-- Enable inlay hint
	if client:supports_method('textDocument/inlayHint') then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

		vim.api.nvim_create_autocmd('LspProgress', {
			buffer = bufnr,
			callback = function(ev)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		})
	end

	-- Enable code lens
	if client:supports_method('textDocument/codeLens') then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end
end

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local bufnr = ev.buf
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		on_attach(client, bufnr)
	end,
})

local diagnostic_icons = Utils.get_diagnostic_icons()

vim.diagnostic.config {
	virtual_text = true,

	-- Setup diagnostic symbols
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
			[vim.diagnostic.severity.WARN]  = diagnostic_icons.Warn,
			[vim.diagnostic.severity.INFO]  = diagnostic_icons.Info,
			[vim.diagnostic.severity.HINT]  = diagnostic_icons.Hint,
		}
	}
}

require('mason').setup()

local function get_ensure_installed_servers()
	local servers = {
		'bashls',
		'lua_ls',
	}

	if vim.fn.executable('go') == 1 then
		table.insert(servers, 'gopls')
	end

	return servers
end

require('mason-lspconfig').setup {
	ensure_installed = get_ensure_installed_servers(),
	automatic_enable = true,
}

local lspconfig_path = vim.fn.stdpath('config') .. '/lsp'
local lsp_server_configs = vim.fn.readdir(lspconfig_path)
for _, config in ipairs(lsp_server_configs) do
	local server = config:match('^(.*)%.lua$')
	if vim.fn.executable(server) == 1 then
		vim.lsp.enable(server, true)
	end
end
