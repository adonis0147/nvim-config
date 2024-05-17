local function setup_dap_key_bindings()
    vim.keymap.set('n', '<m-k>', function() require('dap').continue() end)
    vim.keymap.set('n', '<m-j>', function() require('dap').step_over() end)
    vim.keymap.set('n', '<m-l>', function() require('dap').step_into() end)
    vim.keymap.set('n', '<m-h>', function() require('dap').step_out() end)
    vim.keymap.set('n', '<m-b>', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<m-B>', function() require('dap').set_breakpoint() end)
    vim.keymap.set('n', '<m-p>',
        function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<m-c>',
        function() require('dap').set_breakpoint(vim.fn.input('Condition: '), nil, nil) end)
    vim.keymap.set('n', '<m-d>', function() require('dapui').eval() end)
    vim.keymap.set('n', '<m-f>',
        function() require('dapui').eval(vim.fn.input('Expression: '), { context = 'repl' }) end)
end

local function setup_dap()
    local dap, dapui = require('dap'), require('dapui')

    -- Events
    dap.listeners.after.event_initialized['dapui_config'] = function()
        require('focus').setup({ autoresize = { enable = false } })
        dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
        require('focus').setup({ autoresize = { enable = true } })
    end

    -- Configurations
    dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = 'codelldb',
            args = { '--port', '${port}' },
        }
    }
    dap.configurations.cpp = {
        {
            name = 'Launch file',
            type = 'codelldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
        },
    }
    dap.configurations.c = dap.configurations.cpp

    dap.adapters.bashdb = {
        type = 'executable',
        command = 'bash-debug-adapter',
        name = 'bashdb',
    }
    dap.configurations.sh = {
        {
            type = 'bashdb',
            request = 'launch',
            name = 'Launch file',
            showDebugOutput = true,
            pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
            pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
            trace = true,
            file = '${file}',
            program = '${file}',
            cwd = '${workspaceFolder}',
            pathCat = 'cat',
            pathBash = 'bash',
            pathMkfifo = 'mkfifo',
            pathPkill = 'pkill',
            args = {}, -- Prefer this to argsString
            argsString = '',
            env = {},
            terminalKind = 'integrated',
        }
    }

    dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or '127.0.0.1'
            cb({
                type = 'server',
                port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                host = host,
                options = {
                    source_filetype = 'python',
                },
            })
        else
            cb({
                type = 'executable',
                command = vim.loop.os_homedir() .. '/.local/share/nvim/mason/packages/debugpy/venv/bin/python3',
                args = { '-m', 'debugpy.adapter' },
                options = {
                    source_filetype = 'python',
                },
            })
        end
    end
    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',
            name = 'Launch file',

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = '${file}', -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                    return cwd .. '/venv/bin/python'
                elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                    return cwd .. '/.venv/bin/python'
                else
                    return 'python3'
                end
            end,
        },
    }

    setup_dap_key_bindings()

    require('dap.ext.vscode').load_launchjs(nil, {
        ['codelldb'] = { 'cpp', 'c', 'rust' },
        ['bashdb'] = { 'sh' }
    })
end

local function setup_nvim_dap_ui()
    require('dapui').setup {}
end

local function setup_nvim_dap_virtual_text()
    require('nvim-dap-virtual-text').setup {}
end

return {
    setup_dap                   = setup_dap,
    setup_nvim_dap_virtual_text = setup_nvim_dap_virtual_text,
    setup_nvim_dap_ui           = setup_nvim_dap_ui,
}
