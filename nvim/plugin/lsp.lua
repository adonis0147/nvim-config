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

	-- Enable auto-trigger signature help
	if client:supports_method('textDocument/signatureHelp') then
		local group = vim.api.nvim_create_augroup('lsp_signature_' .. bufnr, { clear = true })
		local timer = nil

		-- Get trigger characters from LSP server
		local trigger_chars = (
			client.server_capabilities.signatureHelpProvider and
			client.server_capabilities.signatureHelpProvider.triggerCharacters
		) or {}

		if #trigger_chars > 0 then
			local function get_last_char()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local line = vim.api.nvim_get_current_line()
				local col = cursor[2]
				return col > 0 and line:sub(col, col) or ''
			end

			local function check_signature_help()
				if vim.tbl_contains(trigger_chars, get_last_char()) then
					if timer then vim.fn.timer_stop(timer) end
					timer = vim.fn.timer_start(50, function() vim.lsp.buf.signature_help() end)
				end
			end

			vim.api.nvim_create_autocmd({ 'TextChangedI', 'TextChangedP', 'InsertEnter' }, {
				group = group,
				buffer = bufnr,
				callback = check_signature_help,
			})
		end
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

vim.lsp.util.open_floating_preview = Utils.overwrite(vim.lsp.util.open_floating_preview, function(contents, syntax, opts)
	opts = opts or {}
	opts.max_width = opts.max_width or math.min(120, vim.o.columns - 4)
	opts.max_height = opts.max_height or math.min(20, vim.o.lines - 4)
	return contents, syntax, opts
end)


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
