local function setup_dap()
    local dap, dapui = require("dap"), require("dapui")

    -- Events
    dap.listeners.after.event_initialized["dapui_config"] = function()
        require("focus").setup({ autoresize = { enable = false } })
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        require("focus").setup({ autoresize = { enable = true } })
    end

    -- Configurations
    dap.adapters.lldb = {
        type = 'executable',
        command = 'lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb',
    }
    dap.configurations.cpp = {
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            initCommands = function()
                if vim.fn.filereadable(vim.fn.getcwd() .. '/.lldbinit') == 1 then
                    return { 'command source ${workspaceFolder}/.lldbinit' }
                end
                return {}
            end,
            stopOnEntry = false,
            args = {},
        },
    }
    dap.configurations.c = dap.configurations.cpp
end

local function setup_nvim_dap_ui()
    require("dapui").setup {}
end

local function setup_nvim_dap_virtual_text()
    require("nvim-dap-virtual-text").setup {}
end

return {
    setup_dap                   = setup_dap,
    setup_nvim_dap_virtual_text = setup_nvim_dap_virtual_text,
    setup_nvim_dap_ui           = setup_nvim_dap_ui,
}
