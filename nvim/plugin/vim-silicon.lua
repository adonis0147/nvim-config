vim.pack.add({ 'https://github.com/segeljakt/vim-silicon' }, { confirm = false })


--[[
	silicon --theme 'Monokai Extended' --background '#FFF0' --font 'Hack;PingFang SC' \
		--pad-horiz 0 --pad-vert 0 --no-window-controls
--]]
vim.g.silicon = {
	theme               = 'Monokai Extended',
	background          = '#FFF0',
	font                = 'Hack;PingFang SC',
	['pad-horiz']       = 0,
	['pad-vert']        = 0,
	['window-controls'] = false
}
