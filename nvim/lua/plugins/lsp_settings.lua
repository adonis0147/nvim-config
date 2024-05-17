-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local function on_attach(client, bufnr)
    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
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

local function setup_lsp_attach()
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            assert(client, 'client is nil.')
            on_attach(client, bufnr)
        end,
    })
end

local function get_extra_servers(lsp_server_settings)
    local servers = {}

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
    require('mason').setup {}
    require('mason-lspconfig').setup {}

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

    local has_custom_settings, custom_settings = pcall(require, 'plugins.lsp_custom_settings')
    local default_setup = function(server)
        local opts = {}
        if enhance_server_opts[server] then
            -- Enhance the default opts with the server-specific ones
            enhance_server_opts[server](opts)
        end

        if has_custom_settings then
            if custom_settings.opts[server] then
                custom_settings.opts[server](opts)
            end
        end

        require('lspconfig')[server].setup(opts)
    end

    require('mason-lspconfig').setup_handlers {
        default_setup,
        ['rust_analyzer'] = function() end,
    }

    local servers = get_extra_servers(enhance_server_opts);
    for server, _ in pairs(servers) do
        default_setup(server)
    end
end

local function setup_null_ls_nvim()
    local null_ls = require('null-ls')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    null_ls.setup {
        capabilities = capabilities,
        sources = {
            null_ls.builtins.code_actions.shellcheck,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.formatting.shfmt,
        },
    }
end

return {
    setup_lsp_attach   = setup_lsp_attach,
    setup_mason        = setup_mason,
    setup_null_ls_nvim = setup_null_ls_nvim,
}
