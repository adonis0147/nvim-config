Utils = {}

Utils.hook_pack_changed = function(pack_name, kinds, callback)
	vim.api.nvim_create_autocmd('PackChanged', {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == pack_name and vim.tbl_contains(kinds, kind) then
				if not ev.data.active then vim.cmd.packadd(pack_name) end
				callback(ev)
			end
		end
	})
end

Utils.get_diagnostic_icons = function()
	return {
		Error = '󰅚 ', -- x000f015a
		Warn  = '󰀪 ', -- x000f002a
		Info  = '󰋽 ', -- x000f02fd
		Hint  = '󰌶 ', -- x000f0336
	}
end

Utils.overwrite = function(func, interceptor)
	return function(...)
		return func(interceptor(...))
	end
end
