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

local function setup_flash_nvim_keymaps()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { noremap = true })
end

local function setup_telescope_nvim_keymaps()
    local telescope = require('telescope')
    vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, { noremap = true })
    vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fw', '<cmd>Telescope grep_string<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fa', '<cmd>Telescope aerial<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>fd', '<cmd>Telescope dap configurations<cr>', { noremap = true })
end

local function setup_qf_nvim_keymaps()
    local function qf_toggle(type)
        local ok, error = pcall(function() require('qf').toggle(type, true) end)
        if not ok then
            assert(error)
            vim.notify(string.match(error, 'E%d+:.*'), vim.log.levels.ERROR)
        end
    end

    local function close_qf_or_buffer()
        local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        local is_quickfix = (win_info['quickfix'] == 1)
        local is_loclist = (win_info['loclist'] == 1)

        local ok, error = pcall(function()
            if is_quickfix then
                if not is_loclist then
                    require('qf').toggle('c', true)
                else
                    require('qf').toggle('l', true)
                end
            else
                vim.cmd('bdelete')
            end
        end)
        if not ok then
            assert(error)
            vim.notify(string.match(error, 'E%d+:.*'), vim.log.levels.ERROR)
        end
    end

    vim.keymap.set('n', '<leader>q', function() qf_toggle('c') end, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>l', function() qf_toggle('l') end, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>e', close_qf_or_buffer, { noremap = true })
end

local function setup_vim_easy_align_keymaps()
    vim.keymap.set('x', '<enter>', '<plug>(EasyAlign)', {})
    vim.keymap.set('n', 'ga', '<plug>(EasyAlign)', {})
end

local function setup_aerial_nvim_keymaps()
    vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
end

return {
    setup_nvim_bufferline_keymaps    = setup_nvim_bufferline_keymaps,
    setup_close_buffers_nvim_keymaps = setup_close_buffers_nvim_keymaps,
    setup_flash_nvim_keymaps         = setup_flash_nvim_keymaps,
    setup_telescope_nvim_keymaps     = setup_telescope_nvim_keymaps,
    setup_qf_nvim_keymaps            = setup_qf_nvim_keymaps,
    setup_vim_easy_align_keymaps     = setup_vim_easy_align_keymaps,
    setup_aerial_nvim_keymaps        = setup_aerial_nvim_keymaps,
}
