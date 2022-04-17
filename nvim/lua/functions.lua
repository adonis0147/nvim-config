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

return {
    toggle_spell_checking = toggle_spell_checking,
}
