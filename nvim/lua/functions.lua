--------------------------------------------------------------------------------
--                                 Functions                                  --
--------------------------------------------------------------------------------

local function toggle_spell_checking()
    if not vim.wo.spell then
        vim.wo.spell = true
    else
        vim.wo.spell = false
    end
    print('Spell checking: ' .. (vim.wo.spell and 'on' or 'off'))
end

local function delete_other_buffers(force)
    if not force then
        pcall(function(cmd) vim.cmd(cmd) end, 'BDelete other')
    else
        vim.cmd('BDelete! other')
    end
    vim.cmd('redraw!')
end

return {
    toggle_spell_checking = toggle_spell_checking,
    delete_other_buffers  = delete_other_buffers,
}
