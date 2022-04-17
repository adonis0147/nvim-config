--------------------------------------------------------------------------------
--                                 Functions                                  --
--------------------------------------------------------------------------------

local function toggle_spell_checking()
    if not vim.opt.spell:get() then
        vim.opt.spell = true
    else
        vim.opt.spell = false
    end
end

local function delete_other_buffers(force)
    if not force then
        vim.api.nvim_command('BDelete other')
    else
        vim.api.nvim_command('BDelete! other')
    end
    vim.api.nvim_command('redraw')
end

return {
    toggle_spell_checking = toggle_spell_checking,
    delete_other_buffers = delete_other_buffers,
}
