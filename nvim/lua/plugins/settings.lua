--------------------------------------------------------------------------------
--                                  Settings                                  --
--------------------------------------------------------------------------------

-- monokai.nvim
require('monokai').setup { palette = require('monokai').pro }

-- lualine.nvim
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'powerline',
        component_separators = {},
        section_separators = {},
    }
}

-- telescope.nvim
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
        }
    }
}
telescope.load_extension('fzf')
vim.api.nvim_command('autocmd User TelescopePreviewerLoaded setlocal wrap')

-- project.nvim
require('project_nvim').setup {
    detection_methods = { 'pattern' },
    patterns = { '.git' },
    silent_chdir = false,
}
telescope.load_extension('projects')

-- nvim-bufferline
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
            text = '[×]',
            delete_buffer_on_left_click = true,
        },
    },
}

-- hop.nvim
require('hop').setup {}

-- nvim-autopairs
require('nvim-autopairs').setup {}

-- kommentary
require('kommentary')
vim.g.kommentary_create_default_mappings = false

-- nvim-cmp
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
        ['<c-p>'] = cmp.mapping.select_prev_item(),
        ['<c-n>'] = cmp.mapping.select_next_item(),
        ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<c-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
        ['<tab>'] = select_next_item,
        ['<s-tab>'] = select_prev_item,
        ['<c-l>'] = select_next_item,
        ['<c-h>'] = select_prev_item,
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
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

-- LSP settings
require('plugins.lsp_settings')

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    }
}

-- LuaSnip
require('luasnip.loaders.from_vscode').lazy_load()

-- focus.nvim
require('focus').setup { enable = not vim.opt.diff:get() }

-- qf_helper.nvim
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

-- spellsitter.nvim
require('spellsitter').setup {}

-- vim-oscyank
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
    vim.g.oscyank_term = 'tmux'
end

setup_clipboard()
