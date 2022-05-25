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
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, keymap_opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, keymap_opts)
    vim.keymap.set('n', '<space>sh', vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, keymap_opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, keymap_opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, keymap_opts)

    -- Format code on save.
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
            augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
            augroup END
        ]])
    end
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local function setup_lsp_installer()
    require('nvim-lsp-installer').setup {}

    local enhance_server_opts = {
        -- See `:help lsp.txt`
        ['sumneko_lua'] = function(opts)
            opts.settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = { 'vim', 'use' },
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
    }

    local lspconfig = require("lspconfig")
    local servers = require('nvim-lsp-installer.servers').get_installed_servers()
    for _, server in pairs(servers) do
        -- Specify the default options which we'll use to setup all servers
        local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        if enhance_server_opts[server.name] then
            -- Enhance the default opts with the server-specific ones
            enhance_server_opts[server.name](opts)
        end

        lspconfig[server.name].setup(opts)
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
    setup_lsp_installer      = setup_lsp_installer,
    setup_null_ls_nvim       = setup_null_ls_nvim,
}
