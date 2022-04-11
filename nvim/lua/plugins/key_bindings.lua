--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

-- telescope.nvim
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })

-- hop.nvim
vim.api.nvim_set_keymap('n', 's', '<cmd>HopChar2AC<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'S', '<cmd>HopChar2BC<CR>', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>j', '<cmd>HopChar2AC<CR>', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>k', '<cmd>HopChar2BC<CR>', { noremap = true })

-- vim-easy-align
vim.api.nvim_set_keymap('v', '<enter>', '<plug>(EasyAlign)', {})
vim.api.nvim_set_keymap('n', 'ga', '<plug>(EasyAlign)', {})

-- kommentary
vim.api.nvim_set_keymap('n', '<leader>cc', '<plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('x', '<leader>cc', '<plug>kommentary_visual_default', {})

-- LuaSnip
local setup_luasnip_keymaps = function()
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    _G.luasnip_expand_or_jump = function(key)
        if cmp and cmp.visible() then
            cmp.select_next_item()
        elseif luasnip and luasnip.expand_or_jumpable() then
            return t('<plug>luasnip-expand-or-jump')
        elseif check_back_space() then
            return t(key)
        else
            cmp.complete()
        end
        return ''
    end

    _G.luasnip_jump_prev = function(key)
        if cmp and cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip and luasnip.jumpable(-1) then
            return t('<plug>luasnip-jump-prev')
        else
            return t(key)
        end
        return ''
    end

    vim.api.nvim_set_keymap('i', '<tab>', 'v:lua.luasnip_expand_or_jump("<tab>")', { expr = true })
    vim.api.nvim_set_keymap('s', '<tab>', 'v:lua.luasnip_expand_or_jump("<tab>")', { expr = true })
    vim.api.nvim_set_keymap('i', '<s-tab>', 'v:lua.luasnip_jump_prev("<s-tab>")', { expr = true })
    vim.api.nvim_set_keymap('s', '<s-tab>', 'v:lua.luasnip_jump_prev("<s-tab>")', { expr = true })
    vim.api.nvim_set_keymap('i', '<c-l>', 'v:lua.luasnip_expand_or_jump("<c-l>")', { expr = true })
    vim.api.nvim_set_keymap('s', '<c-l>', 'v:lua.luasnip_expand_or_jump("<c-l>")', { expr = true })
    vim.api.nvim_set_keymap('i', '<c-h>', 'v:lua.luasnip_jump_prev("<c-h>")', { expr = true})
    vim.api.nvim_set_keymap('s', '<c-h>', 'v:lua.luasnip_jump_prev("<c-h>")', { expr = true})
end

setup_luasnip_keymaps()
