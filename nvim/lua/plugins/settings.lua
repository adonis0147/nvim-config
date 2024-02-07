--------------------------------------------------------------------------------
--                                  Settings                                  --
--------------------------------------------------------------------------------

local function setup_monokai_nvim()
    require('monokai').setup { palette = require('monokai').pro }
    -- Highlights
    vim.cmd('highlight MatchParen ctermbg=None ctermfg=Red cterm=bold gui=bold')
end

local function setup_lualine_nvim()
    require('lualine').setup {
        options = {
            icons_enabled = false,
            theme = 'powerline',
            component_separators = {},
            section_separators = {},
        },
        sections = {
            lualine_x = {
                {
                    require('lazy.status').updates,
                    cond = require('lazy.status').has_updates,
                    color = { fg = '#ff9e64' },
                },
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
                text = function(buffer) return ' ' .. buffer.index .. ': ' .. buffer.filename .. ' ' end,
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

local function setup_hop_nvim()
    require('hop').setup {}
    require('plugins.key_bindings').setup_hop_nvim_keymaps()
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

local function setup_kommentary()
    vim.g.kommentary_create_default_mappings = false
    require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
    })
    require('plugins.key_bindings').setup_kommentary_keymaps()
end

local function setup_focus_nvim()
    require('focus').setup {}
end

local function setup_telescope_nvim()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    telescope.setup {
        defaults = {
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
            }
        }
    }

    telescope.load_extension('fzf')

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
    cmp.setup.cmdline('/', {
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
        })
    })

    -- Load snippets
    require('luasnip.loaders.from_vscode').load()
end

local function setup_lsp()
    local lsp_settings = require('plugins.lsp_settings')
    lsp_settings.setup_mason()
    lsp_settings.setup_diagnostic_keymaps()
end

local function setup_nvim_treesitter()
    require('nvim-treesitter.configs').setup {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        }
    }
    require('nvim-treesitter.install').prefer_git = true
end

local function setup_null_ls_nvim()
    require('plugins.lsp_settings').setup_null_ls_nvim()
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

local function setup_nvim_osc52()
    require('osc52').setup {}

    local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
    end

    local function paste()
        return {
            vim.fn.split(vim.fn.getreg(''), '\n'),
            vim.fn.getregtype('')
        }
    end

    vim.g.clipboard = {
        name = 'osc52',
        copy = {
            ['+'] = copy,
            ['*'] = copy
        },
        paste = {
            ['+'] = paste,
            ['*'] = paste
        }
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

local function setup_lessspace_vim()
    vim.g.lessspace_blacklist = { 'diff', 'markdown' }
end

local function setup_dap()
    require('plugins.dap_settings').setup_dap()
end

local function setup_nvim_dap_ui()
    require('plugins.dap_settings').setup_nvim_dap_ui()
end

local function setup_nvim_dap_virtual_text()
    require('plugins.dap_settings').setup_nvim_dap_virtual_text()
end

return {
    setup_monokai_nvim          = setup_monokai_nvim,
    setup_lualine_nvim          = setup_lualine_nvim,
    setup_nvim_cokeline         = setup_nvim_cokeline,
    setup_close_buffers_nvim    = setup_close_buffers_nvim,
    setup_hop_nvim              = setup_hop_nvim,
    setup_nvim_autopairs        = setup_nvim_autopairs,
    setup_kommentary            = setup_kommentary,
    setup_focus_nvim            = setup_focus_nvim,
    setup_telescope_nvim        = setup_telescope_nvim,
    setup_project_nvim          = setup_project_nvim,
    setup_nvim_cmp              = setup_nvim_cmp,
    setup_lsp                   = setup_lsp,
    setup_null_ls_nvim          = setup_null_ls_nvim,
    setup_nvim_treesitter       = setup_nvim_treesitter,
    setup_nvim_osc52            = setup_nvim_osc52,
    setup_qf_nvim               = setup_qf_nvim,
    setup_nvim_colorizer_lua    = setup_nvim_colorizer_lua,
    setup_diffview_nvim         = setup_diffview_nvim,
    setup_vim_silicon           = setup_vim_silicon,
    setup_lessspace_vim         = setup_lessspace_vim,
    setup_dap                   = setup_dap,
    setup_nvim_dap_ui           = setup_nvim_dap_ui,
    setup_nvim_dap_virtual_text = setup_nvim_dap_virtual_text,
}
