-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local function setup_diagnostic_keymaps()
    local keymap_opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<space>do', '<cmd>lua vim.diagnostic.open_float()<cr>', keymap_opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', keymap_opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', keymap_opts)
    vim.keymap.set('n', '<space>dl', '<cmd>lua vim.diagnostic.setloclist()<cr>', keymap_opts)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, keymap_opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, keymap_opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, keymap_opts)
    vim.keymap.set('n', '<space>ds', vim.lsp.buf.document_symbol, keymap_opts)
    vim.keymap.set('n', '<space>ci', vim.lsp.buf.incoming_calls, keymap_opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, keymap_opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, keymap_opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, keymap_opts)
    vim.keymap.set('n', '<space>sh', vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, keymap_opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, keymap_opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, keymap_opts)

    -- Format code on save.
    if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[
            augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
        ]])
    end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function get_all_lsp_servers(lsp_server_settings)
    local servers = {}

    local installed_servers = require('mason-lspconfig').get_installed_servers()
    for _, server in ipairs(installed_servers) do
        servers[server] = true
    end

    if lsp_server_settings ~= nil then
        for server, _ in pairs(lsp_server_settings) do
            if vim.fn.executable(server) == 1 then
                servers[server] = true
            end
        end
    end

    local has_custom_settings, custom_settings = pcall(require, 'plugins.lsp_custom_settings')
    if has_custom_settings then
        for server, _ in pairs(custom_settings.opts) do
            if vim.fn.executable(server) == 1 then
                servers[server] = true
            end
        end
    end

    return servers
end

local function setup_mason()
    require("mason").setup {}
    require("mason-lspconfig").setup {}

    local enhance_server_opts = {
        -- See `:help lsp.txt`
        ['lua_ls'] = function(opts)
            opts.settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = { 'vim', 'use', 'packer_plugins' },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        },
                    },
                }
            }
        end,
        ['clangd'] = function(opts)
            opts.cmd = {
                'clangd',
                '--completion-style=detailed',
                '--query-driver=/usr/bin/*',
            }
        end,
        ['pylsp'] = function(opts)
            opts.settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            maxLineLength = 120
                        }
                    }
                }
            }
        end
    }

    local lspconfig = require('lspconfig')
    local has_custom_settings, custom_settings = pcall(require, 'plugins.lsp_custom_settings')

    local servers = get_all_lsp_servers(enhance_server_opts)
    for server, _ in pairs(servers) do
        -- Specify the default options which we'll use to setup all servers
        local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        if enhance_server_opts[server] then
            -- Enhance the default opts with the server-specific ones
            enhance_server_opts[server](opts)
        end

        if has_custom_settings then
            if custom_settings.opts[server] then
                custom_settings.opts[server](opts)
            end
        end

        lspconfig[server].setup(opts)
    end
end

local function setup_null_ls_nvim()
    local null_ls = require('null-ls')
    null_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        sources = {
            null_ls.builtins.code_actions.shellcheck,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.formatting.shfmt,
        },
    }
end

return {
    setup_diagnostic_keymaps = setup_diagnostic_keymaps,
    setup_mason              = setup_mason,
    setup_null_ls_nvim       = setup_null_ls_nvim,
}
