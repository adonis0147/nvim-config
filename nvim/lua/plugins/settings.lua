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

-- project.nvim
require('project_nvim').setup {}

-- nvim-bufferline
local get_hex = require('cokeline/utils').get_hex
require('cokeline').setup({
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
            text = function(buffer) return ' ' .. buffer.filename .. ' ' end,
        },
        {
            text = '[x]',
            delete_buffer_on_left_click = true,
        },
    },
})

-- hop.nvim
require('hop').setup {}

-- nvim-autopairs
require('nvim-autopairs').setup {}

-- kommentary
require('kommentary')
vim.g.kommentary_create_default_mappings = false

-- nvim-cmp
vim.opt.completeopt='menu,menuone,noselect'
local cmp = require('cmp')
local select_next_item = function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    else
        fallback()
    end
end
local select_prev_item = function(fallback)
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
    mapping = {
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
    },
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
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- nvim-lspconfig
require('plugins.lspconfig_settings')

