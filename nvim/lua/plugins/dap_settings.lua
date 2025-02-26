local function setup_dap_key_bindings()
    vim.keymap.set('n', '<m-r>', function() require('dap').run_to_cursor() end)
    vim.keymap.set('n', '<m-k>', function() require('dap').continue() end)
    vim.keymap.set('n', '<m-j>', function() require('dap').step_over() end)
    vim.keymap.set('n', '<m-l>', function() require('dap').step_into() end)
    vim.keymap.set('n', '<m-h>', function() require('dap').step_out() end)
    vim.keymap.set('n', '<m-b>', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<m-B>', function() require('dap').set_breakpoint() end)
    vim.keymap.set('n', '<m-p>',
        function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<m-c>', function() require('dap').set_breakpoint(vim.fn.input('Condition: '), nil, nil) end)
    vim.keymap.set('n', '<m-d>', function() require('dapui').eval() end)
    vim.keymap.set('n', '<m-f>',
        function() require('dapui').eval(vim.fn.input('Expression: '), { context = 'watch' }) end)
    vim.keymap.set('n', '<m-o>',
        function() require('dapui').open({ reset = true }) end)
end

local function merge_custom_dap_configs(type_to_filetypes)
    local dap = require('dap')
    local custom_configs = require('dap.ext.vscode').getconfigs()
    assert(custom_configs, 'launch.json must have a "configurations" key')

    for _, config in ipairs(custom_configs) do
        assert(config.type, 'Configuration in launch.json must have a "type" key')
        assert(config.name, 'Configuration in launch.json must have a "name" key')

        local filetypes = type_to_filetypes[config.type] or { config.type }
        for _, filetype in pairs(filetypes) do
            local dap_configurations = dap.configurations[filetype] or {}
            local merge = false
            for i, dap_config in pairs(dap_configurations) do
                if dap_config.name == config.name then
                    dap_configurations[i] = vim.tbl_extend('force', dap_config, config)
                    merge = true
                end
            end
            if not merge then
                table.insert(dap_configurations, config)
            end
        end
    end
end

local function setup_dap()
    local dap, dapui = require('dap'), require('dapui')

    -- Events
    dap.listeners.after.event_initialized['dapui_config'] = function()
        require('focus').setup({ autoresize = { enable = false }, ui = { signcolumn = false } })
        dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
        require('focus').setup({ autoresize = { enable = true }, ui = { signcolumn = true } })
    end

    -- Configurations
    dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = 'OpenDebugAD7',
    }
    dap.adapters.lldb = {
        name = 'lldb',
        type = 'executable',
        command = vim.fn.exepath('lldb-dap')
    }
    dap.configurations.cpp = {
        {
            name = 'Launch file',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
        },
    }
    local cpp_config
    if vim.fn.executable('OpenDebugAD7') == 1 then
        cpp_config = {
            type = 'cppdbg',
            setupCommands = {
                {
                    text = '-enable-pretty-printing',
                    description = 'enable pretty printing',
                    ignoreFailures = false
                },
            },
        }
    else
        cpp_config = {
            type = 'lldb',
            runInTerminal = true,
        }
    end
    for index, dap_configuration in ipairs(dap.configurations.cpp) do
        dap.configurations.cpp[index] = vim.tbl_extend('force', dap_configuration, cpp_config)
    end
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

    local python_exepath = function()
        local paths = {
            ---@diagnostic disable-next-line: undefined-field
            vim.uv.os_homedir() .. '/.local/share/nvim/mason/packages/debugpy/venv/bin/python3',
            vim.fn.exepath('python3')
        }
        if os.getenv('VIRTUAL_ENV') ~= nil then
            table.insert(paths, 1, os.getenv('VIRTUAL_ENV') .. '/bin/python3')
        end

        for _, path in ipairs(paths) do
            if vim.fn.executable(path) == 1 then
                return path
            end
        end
    end

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
                command = python_exepath(),
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
            console = 'integratedTerminal',
        },
    }

    dap.adapters.delve = function(callback, config)
        if config.mode == 'remote' and config.request == 'attach' then
            callback({
                type = 'server',
                host = config.host or '127.0.0.1',
                port = config.port or '38697'
            })
        else
            callback({
                type = 'server',
                port = '${port}',
                executable = {
                    command = 'dlv',
                    args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
                    detached = vim.fn.has('win32') == 0,
                }
            })
        end
    end
    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
        {
            type = 'delve',
            name = 'Debug',
            request = 'launch',
            program = '${file}'
        },
        {
            type = 'delve',
            name = 'Debug test', -- configuration for debugging test files
            request = 'launch',
            mode = 'test',
            program = '${file}'
        },
        -- works with go.mod packages and sub packages
        {
            type = 'delve',
            name = 'Debug test (go.mod)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}'
        }
    }

    setup_dap_key_bindings()

    merge_custom_dap_configs {
        cppdbg = { 'cpp', 'c' },
        lldb   = { 'cpp', 'c' },
        bashdb = { 'sh' },
    }
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
