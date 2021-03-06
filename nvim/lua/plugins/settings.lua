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
        }
    }
end

local function setup_nvim_bufferline()
    local get_hex = require('cokeline/utils').get_hex
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
    require('nvim-autopairs').setup {}
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

    vim.cmd('PackerLoad telescope-fzf-native.nvim')
    telescope.load_extension('fzf')

    vim.cmd('autocmd User TelescopePreviewerLoaded setlocal wrap')

    vim.cmd('PackerLoad telescope-live-grep-args.nvim')
    require('plugins.key_bindings').setup_telescope_nvim_keymaps()
end

local function setup_project_nvim()
    require('project_nvim').setup {
        detection_methods = { 'pattern' },
        patterns = { '.git' },
        silent_chdir = true,
    }
end

local function setup_nvim_cmp()
    vim.opt.completeopt = 'menu,menuone,noselect'

    local cmp = require('cmp')

    local function select_next_item(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end

    local function select_prev_item(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
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
            ['<tab>'] = select_next_item,
            ['<s-tab>'] = select_prev_item,
            ['<c-l>'] = select_next_item,
            ['<c-h>'] = select_prev_item,
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

    require('plugins.key_bindings').setup_luasnip_keymaps()

    -- Load snippets
    vim.cmd('PackerLoad friendly-snippets')
    require('luasnip.loaders.from_vscode').load()
end

local function setup_lsp()
    local lsp_settings = require('plugins.lsp_settings')
    lsp_settings.setup_lsp_installer()
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
end

local function setup_spellsitter_nvim()
    require('spellsitter').setup {}
end

local function setup_null_ls_nvim()
    require('plugins.lsp_settings').setup_null_ls_nvim()
end

local function setup_qf_helper_nvim()
    require('qf_helper').setup {
        quickfix = {
            default_bindings = false,
            min_height = 10,
        },
        loclist = {
            default_bindings = false,
            min_height = 10,
        },
    }
    require('plugins.key_bindings').setup_qf_helper_nvim_keymaps()
end

local function setup_nvim_colorizer_lua()
    require('colorizer').setup {}
end

local function setup_clipboard()
    local function copy(lines, _)
        vim.fn.OSCYankString(table.concat(lines, '\n'))
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
    vim.g.oscyank_term = 'default'
end

return {
    setup_monokai_nvim       = setup_monokai_nvim,
    setup_lualine_nvim       = setup_lualine_nvim,
    setup_nvim_bufferline    = setup_nvim_bufferline,
    setup_close_buffers_nvim = setup_close_buffers_nvim,
    setup_hop_nvim           = setup_hop_nvim,
    setup_nvim_autopairs     = setup_nvim_autopairs,
    setup_kommentary         = setup_kommentary,
    setup_focus_nvim         = setup_focus_nvim,
    setup_telescope_nvim     = setup_telescope_nvim,
    setup_project_nvim       = setup_project_nvim,
    setup_nvim_cmp           = setup_nvim_cmp,
    setup_lsp                = setup_lsp,
    setup_null_ls_nvim       = setup_null_ls_nvim,
    setup_nvim_treesitter    = setup_nvim_treesitter,
    setup_spellsitter_nvim   = setup_spellsitter_nvim,
    setup_qf_helper_nvim     = setup_qf_helper_nvim,
    setup_nvim_colorizer_lua = setup_nvim_colorizer_lua,
    setup_clipboard          = setup_clipboard,
}
