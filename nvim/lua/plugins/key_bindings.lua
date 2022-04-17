--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

-- telescope.nvim
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fw', '<cmd>Telescope grep_string<cr>', { noremap = true })

-- nvim-bufferline
for i = 1, 9 do
    vim.api.nvim_set_keymap('n', ('<m-%s>'):format(i), ('<Plug>(cokeline-focus-%s)'):format(i), { silent = true })
end
vim.api.nvim_set_keymap('n', '<leader>n', '<Plug>(cokeline-focus-prev)', {})
vim.api.nvim_set_keymap('n', '<leader>m', '<Plug>(cokeline-focus-next)', {})
vim.api.nvim_set_keymap('n', '<leader>N', '<Plug>(cokeline-switch-prev)', {})
vim.api.nvim_set_keymap('n', '<leader>M', '<Plug>(cokeline-switch-next)', {})

-- close-buffers.nvim
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>BDelete other<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>B', '<cmd>BDelete! other<cr>', { noremap = true })

-- hop.nvim
vim.api.nvim_set_keymap('n', 's', '<cmd>HopChar2AC<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'S', '<cmd>HopChar2BC<CR>', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>j', '<cmd>HopChar2AC<CR>', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>k', '<cmd>HopChar2BC<CR>', { noremap = true })

-- vim-easy-align
vim.api.nvim_set_keymap('x', '<enter>', '<plug>(EasyAlign)', {})
vim.api.nvim_set_keymap('n', 'ga', '<plug>(EasyAlign)', {})

-- kommentary
vim.api.nvim_set_keymap('n', '<leader>cc', '<plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('x', '<leader>cc', '<plug>kommentary_visual_default', {})

-- LuaSnip
local function setup_luasnip_keymaps()
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local function check_back_space()
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
    vim.api.nvim_set_keymap('i', '<c-h>', 'v:lua.luasnip_jump_prev("<c-h>")', { expr = true })
    vim.api.nvim_set_keymap('s', '<c-h>', 'v:lua.luasnip_jump_prev("<c-h>")', { expr = true })
end

setup_luasnip_keymaps()

-- qf_helper.nvim
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>QFToggle!<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>LLToggle!<cr>', { noremap = true, silent = true })
