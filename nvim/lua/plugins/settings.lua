--------------------------------------------------------------------------------
--                                  Settings                                  --
--------------------------------------------------------------------------------

local diagnostic_icons = {
    Error = '󰅚 ', -- x000f015a
    Warn  = '󰀪 ', -- x000f002a
    Info  = '󰋽 ', -- x000f02fd
    Hint  = '󰌶 ', -- x000f0336
}

local function setup_monokai_nvim()
    require('monokai').setup { palette = require('monokai').pro }
    -- Highlights
    vim.cmd('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold gui=bold')
end

local function setup_lualine_nvim()
    require('lualine').setup {
        options = {
            theme = 'powerline',
        },
        sections = {
            lualine_x = {
                {
                    require('lazy.status').updates,
                    cond = require('lazy.status').has_updates,
                    color = { fg = '#ff9e64' },
                },
                'encoding', 'fileformat', 'filetype',
            },
        },
    }
end

local function setup_nvim_cokeline()
    local get_hex = require('cokeline.hlgroups').get_hl_attr
    require('cokeline').setup {
        show_if_buffers_are_at_least = 2,
        default_hl = {
            fg = function(buffer)
                return buffer.is_focused and get_hex('ColorColumn', 'bg') or get_hex('Normal', 'fg')
            end,
            bg = function(buffer)
                return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('ColorColumn', 'bg')
            end,
        },
        components = {
            {
                text = function(buffer) return ' ' .. buffer.devicon.icon end,
                fg = function(buffer) return buffer.devicon.color end,
            },
            {
                text = function(buffer) return buffer.index .. ': ' .. buffer.filename .. ' ' end,
            },
            {
                text = function(buffer)
                    return buffer.is_modified and '●' or '✘'
                end,
                fg = function(buffer)
                    if buffer.is_modified then
                        return 'Orange'
                    elseif buffer.is_focused then
                        return 'DarkGreen'
                    else
                        return 'LightGreen'
                    end
                end,
                delete_buffer_on_left_click = true,
            },
            {
                text = ' '
            }
        },
    }

    require('plugins.key_bindings').setup_nvim_bufferline_keymaps()
end

local function setup_close_buffers_nvim()
    require('close_buffers').setup {}
    require('plugins.key_bindings').setup_close_buffers_nvim_keymaps()
end

local function setup_flash_nvim()
    require('flash').setup {
        modes = {
            char = {
                enabled = false
            }
        }
    }
    require('plugins.key_bindings').setup_flash_nvim_keymaps()
end

local function setup_nvim_autopairs()
    local npairs = require('nvim-autopairs')
    npairs.setup {
        check_ts = true,
        enable_afterquote = false,
        disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'dap-repl' },
    }

    local cond = require('nvim-autopairs.conds')
    local ts_conds = require('nvim-autopairs.ts-conds')
    local quote = require('nvim-autopairs.rules.basic').quote_creator(npairs.config)

    npairs.remove_rule('"')
    npairs.add_rule(quote('"', '"', { '-vim', '-sh', '-zsh' }))
    npairs.add_rule(quote('"', '"', 'vim'):with_pair(cond.not_before_regex('^%s*$', -1)))
    npairs.add_rule(quote('"', '"', { 'sh', 'zsh' }):with_pair(function(opts)
        if require('nvim-treesitter.parsers').has_parser() then
            return ts_conds.is_not_ts_node({ 'string', 'comment' })(opts)
        else
            return cond.not_add_quote_inside_quote()(opts)
        end
    end))
end

local function setup_nvim_surround()
    require('nvim-surround').setup {}
end

local function setup_focus_nvim()
    require('focus').setup {}

    local ignore_filetypes = { 'aerial', 'qf' }
    local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

    local augroup =
        vim.api.nvim_create_augroup('FocusDisable', { clear = true })

    vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
            if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
            then
                vim.w.focus_disable = true
            else
                vim.w.focus_disable = false
            end
        end,
        desc = 'Disable focus autoresize for BufType',
    })

    vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
            if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                vim.b.focus_disable = true
            else
                vim.b.focus_disable = false
            end
        end,
        desc = 'Disable focus autoresize for FileType',
    })

    vim.api.nvim_create_autocmd('TermOpen', {
        callback = function(_)
            vim.g.focus_disable = true
        end,
    })

    vim.api.nvim_create_autocmd('TermClose', {
        callback = function(_)
            vim.g.focus_disable = false
        end,
    })
end

local function setup_telescope_nvim()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    telescope.setup {
        defaults = {
            path_display = {
                'truncate'
            },
            mappings = {
                i = {
                    ['<c-j>'] = actions.move_selection_next,
                    ['<c-k>'] = actions.move_selection_previous,
                }
            }
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = 'smart_case',
            },
            live_grep_args = {
                mappings = {
                    i = {
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                    }
                }
            },
        }
    }

    telescope.load_extension('fzf')
    telescope.load_extension('aerial')
    telescope.load_extension('dap')

    vim.cmd('autocmd User TelescopePreviewerLoaded setlocal wrap')

    require('plugins.key_bindings').setup_telescope_nvim_keymaps()
end

local function setup_project_nvim()
    require('project_nvim').setup {
        detection_methods = { 'pattern' },
        patterns = { '.git' },
        silent_chdir = true,
        scope_chdir = 'tab',
    }
end

local function setup_nvim_cmp()
    vim.opt.completeopt = 'menu,menuone,noselect'

    local luasnip = require('luasnip')
    local cmp = require('cmp')

    local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local function select_next_item(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end

    local function select_prev_item(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end

    cmp.setup {
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<c-b>'] = cmp.mapping.scroll_docs(-4),
            ['<c-f>'] = cmp.mapping.scroll_docs(4),
            ['<c-e>'] = cmp.mapping.abort(),
            ['<cr>'] = cmp.mapping.confirm({ select = true }),
            ['<tab>'] = cmp.mapping(select_next_item, { 'i', 's' }),
            ['<s-tab>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
            ['<c-l>'] = cmp.mapping(select_next_item, { 'i', 's' }),
            ['<c-h>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
        }, {
            { name = 'buffer' },
            { name = 'path' },
        })
    }

    -- cmp-cmdline
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- Load snippets
    require('luasnip.loaders.from_vscode').load()
end

local function setup_lsp()
    local lsp_settings = require('plugins.lsp_settings')
    lsp_settings.setup_lsp_attach()
    lsp_settings.setup_mason()

    vim.diagnostic.config {
        virtual_text = true,

        -- Setup diagnostic symbols
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
                [vim.diagnostic.severity.WARN]  = diagnostic_icons.Warn,
                [vim.diagnostic.severity.INFO]  = diagnostic_icons.Info,
                [vim.diagnostic.severity.HINT]  = diagnostic_icons.Hint,
            }
        }
    }
end

local function setup_nvim_treesitter()
    require('nvim-treesitter.configs').setup {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true
        },
    }
end

local function setup_aerial_nvim()
    local aerial = require('aerial')
    aerial.setup {
        show_guides = true,
        on_attach = function(bufnr)
            aerial.tree_set_collapse_level(bufnr, 0)
        end,
    }
    require('plugins.key_bindings').setup_aerial_nvim_keymaps()
end

local function setup_qf_nvim()
    require('qf').setup {
        l = {
            max_height = 10,
            auto_resize = false,
        },
        c = {
            max_height = 10,
            auto_resize = false,
        },
    }
    require('plugins.key_bindings').setup_qf_nvim_keymaps()

    for type, icon in pairs(diagnostic_icons) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end
end

local function setup_nvim_colorizer_lua()
    require('colorizer').setup {}
end

local function setup_diffview_nvim()
    local actions = require('diffview.actions')

    require('diffview').setup {
        use_icons = false,
        view = {
            merge_tool = {
                layout = 'diff4_mixed',
            },
        },
        hooks = {
            view_opened = function(_)
                require('focus').focus_disable()
            end
        },
        keymaps = {
            diff4 = {
                {
                    {
                        'n', 'x'
                    },
                    '1do', actions.diffget('ours'),
                    { desc = 'Obtain the diff hunk from the OURS version of the file' }
                },
                {
                    {
                        'n', 'x'
                    },
                    '2do', actions.diffget('base'),
                    { desc = 'Obtain the diff hunk from the BASE version of the file' }
                },
            },
        }
    }
end

local function setup_guess_indent_nvim()
    require('guess-indent').setup {}
end

local function setup_indent_blankline_nvim()
    require('ibl').setup {
        indent = { char = '¦' },
        scope = { enabled = false },
    }
end

local function setup_vim_silicon()
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
end

local function setup_dap()
    require('plugins.dap_settings').setup_dap()

    local signs = {
        Breakpoint          = '',
        BreakpointCondition = '',
        LogPoint            = '',
        Stopped             = '',
        BreakpointRejected  = '',
    }
    for type, icon in pairs(signs) do
        local highlight = 'Dap' .. type
        local config = { text = icon, texthl = highlight }
        if type == 'Stopped' then
            config.linehl = highlight .. 'Line'
            config.numhl = highlight .. 'Line'
        end
        vim.fn.sign_define(highlight, config)
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        desc = 'Prevent colorscheme clearing self-defined DAP marker colors',
        callback = function()
            -- Reuse current SignColumn background (except for DapStoppedLine)
            local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
            -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
            -- convert to 6 digit hex value starting with #
            local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
            ---@diagnostic disable-next-line: undefined-field
            local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

            vim.api.nvim_set_hl(0, 'DapBreakpoint',
                { fg = '#e95678', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapBreakpointCondition',
                { fg = '#e6db74', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#66d9ef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#a6e22e', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#3d5213', ctermbg = 'Green' })
            vim.api.nvim_set_hl(0, 'DapBreakpointRejected',
                { fg = '#8F908A', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
        end
    })

    -- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
    vim.cmd.colorscheme(vim.g.colors_name)
end

local function setup_nvim_dap_ui()
    require('plugins.dap_settings').setup_nvim_dap_ui()
end

local function setup_nvim_dap_virtual_text()
    require('plugins.dap_settings').setup_nvim_dap_virtual_text()
end

local function setup_nvim_dap_go()
    require('plugins.dap_settings').setup_nvim_dap_go()
end

return {
    setup_monokai_nvim          = setup_monokai_nvim,
    setup_lualine_nvim          = setup_lualine_nvim,
    setup_nvim_cokeline         = setup_nvim_cokeline,
    setup_close_buffers_nvim    = setup_close_buffers_nvim,
    setup_flash_nvim            = setup_flash_nvim,
    setup_nvim_autopairs        = setup_nvim_autopairs,
    setup_nvim_surround         = setup_nvim_surround,
    setup_focus_nvim            = setup_focus_nvim,
    setup_telescope_nvim        = setup_telescope_nvim,
    setup_project_nvim          = setup_project_nvim,
    setup_nvim_cmp              = setup_nvim_cmp,
    setup_lsp                   = setup_lsp,
    setup_nvim_treesitter       = setup_nvim_treesitter,
    setup_aerial_nvim           = setup_aerial_nvim,
    setup_qf_nvim               = setup_qf_nvim,
    setup_nvim_colorizer_lua    = setup_nvim_colorizer_lua,
    setup_diffview_nvim         = setup_diffview_nvim,
    setup_guess_indent_nvim     = setup_guess_indent_nvim,
    setup_indent_blankline_nvim = setup_indent_blankline_nvim,
    setup_vim_silicon           = setup_vim_silicon,
    setup_dap                   = setup_dap,
    setup_nvim_dap_ui           = setup_nvim_dap_ui,
    setup_nvim_dap_virtual_text = setup_nvim_dap_virtual_text,
    setup_nvim_dap_go           = setup_nvim_dap_go,
}
