local api = vim.api
local util = require('vim.lsp.util')
local ms = require('vim.lsp.protocol').Methods

local M = {}

local attached_buffers = {}
local request_ids = {}
local namespaces = setmetatable({}, {
	__index = function(t, client_id)
		local namespace = api.nvim_create_namespace('custom.lsp.codelens:' .. client_id)
		rawset(t, client_id, namespace)
		return namespace
	end,
})

local function schedule_refresh(bufnr, delay)
	vim.defer_fn(function()
		if api.nvim_buf_is_loaded(bufnr) then
			M.refresh(bufnr)
		end
	end, delay)
end

local function clear(bufnr, client_id)
	if client_id then
		api.nvim_buf_clear_namespace(bufnr, namespaces[client_id], 0, -1)
		return
	end

	for _, namespace in pairs(namespaces) do
		api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
	end
end

local function bump_request_id(bufnr, client_id)
	request_ids[bufnr] = request_ids[bufnr] or {}
	request_ids[bufnr][client_id] = (request_ids[bufnr][client_id] or 0) + 1
	return request_ids[bufnr][client_id]
end

local function is_stale_request(bufnr, client_id, request_id)
	return request_ids[bufnr] == nil or request_ids[bufnr][client_id] ~= request_id
end

local function render(client_id, bufnr, lenses)
	local namespace = namespaces[client_id]
	local by_line = {}
	for _, lens in ipairs(lenses or {}) do
		if lens.command then
			local row = lens.range.start.line
			by_line[row] = by_line[row] or {}
			table.insert(by_line[row], lens)
		end
	end

	if vim.tbl_isempty(by_line) then
		return
	end

	api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

	for row, line_lenses in pairs(by_line) do
		table.sort(line_lenses, function(a, b)
			return a.range.start.character < b.range.start.character
		end)

		local chunks = {}
		for i, lens in ipairs(line_lenses) do
			table.insert(chunks, { lens.command.title:gsub('%s+', ' '), 'LspCodeLens' })
			if i < #line_lenses then
				table.insert(chunks, { ' | ', 'LspCodeLensSeparator' })
			end
		end

		api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
			virt_text = chunks,
			hl_mode = 'combine',
		})
	end
end

local function resolve_lenses(client_id, bufnr, lenses, request_id)
	local client = vim.lsp.get_client_by_id(client_id)
	if not client then
		return
	end

	local unresolved = vim.tbl_filter(function(lens)
		return lens.command == nil
	end, lenses)
	if vim.tbl_isempty(unresolved) then
		return
	end

	local pending = #unresolved
	local finished = false

	local function redraw()
		if finished then
			return
		end
		finished = true
		if not api.nvim_buf_is_loaded(bufnr) or is_stale_request(bufnr, client_id, request_id) then
			return
		end
		render(client_id, bufnr, lenses)
	end

	vim.defer_fn(redraw, 1500)

	for _, lens in ipairs(unresolved) do
		client:request(ms.codeLens_resolve, lens, function(err, resolved)
			if err == nil and resolved and resolved.command then
				lens.command = resolved.command
			end

			pending = pending - 1
			if pending == 0 then
				redraw()
			end
		end, bufnr)
	end
end

function M.refresh(bufnr)
	bufnr = vim._resolve_bufnr(bufnr or 0)
	if not api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = ms.textDocument_codeLens })
	if #clients == 0 then
		return
	end

	local params = { textDocument = util.make_text_document_params(bufnr) }
	for _, client in ipairs(clients) do
		local client_id = client.id
		local request_id = bump_request_id(bufnr, client_id)
		client:request(ms.textDocument_codeLens, params, function(err, result)
			if not api.nvim_buf_is_loaded(bufnr) then
				return
			end

			if err or is_stale_request(bufnr, client_id, request_id) then
				return
			end

			if not result or vim.tbl_isempty(result) then
				return
			end

			render(client_id, bufnr, result)
			resolve_lenses(client_id, bufnr, result, request_id)
		end, bufnr)
	end
end

function M.attach(bufnr)
	bufnr = vim._resolve_bufnr(bufnr)
	if attached_buffers[bufnr] then
		schedule_refresh(bufnr, 3000)
		return
	end

	attached_buffers[bufnr] = true
	local group = api.nvim_create_augroup('custom_lsp_codelens_' .. bufnr, { clear = true })

	api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufWritePost' }, {
		group = group,
		buffer = bufnr,
		callback = function()
			M.refresh(bufnr)
		end,
	})

	api.nvim_create_autocmd('LspDetach', {
		group = group,
		buffer = bufnr,
		callback = function()
			if vim.tbl_isempty(vim.lsp.get_clients({ bufnr = bufnr, method = ms.textDocument_codeLens })) then
				clear(bufnr)
				request_ids[bufnr] = nil
				attached_buffers[bufnr] = nil
			end
		end,
	})

	schedule_refresh(bufnr, 3000)
end

return M
