--------------------------------------------------------------------------------
--                                  Mappings                                  --
--------------------------------------------------------------------------------

local function setup_nvim_bufferline_keymaps()
    for i = 1, 9 do
        vim.keymap.set('n', ('<m-%s>'):format(i), ('<Plug>(cokeline-focus-%s)'):format(i), { silent = true })
    end
    vim.keymap.set('n', '<leader>n', '<Plug>(cokeline-focus-prev)', {})
    vim.keymap.set('n', '<leader>m', '<Plug>(cokeline-focus-next)', {})
    vim.keymap.set('n', '<leader>N', '<Plug>(cokeline-switch-prev)', {})
    vim.keymap.set('n', '<leader>M', '<Plug>(cokeline-switch-next)', {})
end

local function setup_close_buffers_nvim_keymaps()
    vim.keymap.set('n', '<leader>b', function() require('functions').delete_other_buffers(false) end, { noremap = true })
    vim.keymap.set('n', '<leader>B', function() require('functions').delete_other_buffers(true) end, { noremap = true })
end

local function setup_hop_nvim_keymaps()
    vim.keymap.set('n', 's', '<cmd>HopChar2AC<CR>', { noremap = true })
    vim.keymap.set('n', 'S', '<cmd>HopChar2BC<CR>', { noremap = true })
    vim.keymap.set('x', '<leader>j', '<cmd>HopChar2AC<CR>', { noremap = true })
    vim.keymap.set('x', '<leader>k', '<cmd>HopChar2BC<CR>', { noremap = true })
end

local function setup_kommentary_keymaps()
    vim.keymap.set('n', '<leader>cc', '<plug>kommentary_line_default', {})
    vim.keymap.set('x', '<leader>cc', '<plug>kommentary_visual_default', {})
end

local function setup_telescope_nvim_keymaps()
    local telescope = require('telescope')
    vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, { noremap = true })
    vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fw', '<cmd>Telescope grep_string<cr>', { noremap = true })
end

local function setup_luasnip_keymaps()
    vim.cmd('PackerLoad LuaSnip')

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

    vim.keymap.set({ 'i', 's' }, '<tab>', 'v:lua.luasnip_expand_or_jump("<tab>")', { expr = true })
    vim.keymap.set({ 'i', 's' }, '<s-tab>', 'v:lua.luasnip_jump_prev("<s-tab>")', { expr = true })
    vim.keymap.set({ 'i', 's' }, '<c-l>', 'v:lua.luasnip_expand_or_jump("<c-l>")', { expr = true })
    vim.keymap.set({ 'i', 's' }, '<c-h>', 'v:lua.luasnip_jump_prev("<c-h>")', { expr = true })
end

local function setup_qf_nvim_keymaps()
    local function close_qf_or_buffer()
        local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        local is_quickfix = (win_info['quickfix'] == 1)
        local is_loclist = (win_info['loclist'] == 1)

        if is_quickfix then
            if not is_loclist then
                require('qf').toggle('c', true)
            else
                require('qf').toggle('l', true)
            end
        else
            vim.cmd('bdelete')
        end
    end

    vim.keymap.set('n', '<leader>q', '<cmd>lua require("qf").toggle("c", true)<cr>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>l', '<cmd>lua require("qf").toggle("l", true)<cr>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>e', close_qf_or_buffer, { noremap = true })
end

local function setup_vim_easy_align_keymaps()
    vim.keymap.set('x', '<enter>', '<plug>(EasyAlign)', {})
    vim.keymap.set('n', 'ga', '<plug>(EasyAlign)', {})
end

return {
    setup_nvim_bufferline_keymaps    = setup_nvim_bufferline_keymaps,
    setup_close_buffers_nvim_keymaps = setup_close_buffers_nvim_keymaps,
    setup_hop_nvim_keymaps           = setup_hop_nvim_keymaps,
    setup_kommentary_keymaps         = setup_kommentary_keymaps,
    setup_telescope_nvim_keymaps     = setup_telescope_nvim_keymaps,
    setup_luasnip_keymaps            = setup_luasnip_keymaps,
    setup_qf_nvim_keymaps            = setup_qf_nvim_keymaps,
    setup_vim_easy_align_keymaps     = setup_vim_easy_align_keymaps,
}
