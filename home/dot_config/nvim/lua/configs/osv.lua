local map_desc = require("utils.mappings").map_desc

local dap = require("dap")
-- https://www.lazyvim.org/extras/dap/nlua
dap.adapters.nlua = function(callback, conf)
    local adapter = {
        type = "server",
        -- host = config.host or "172.17.0.1", -- "192.168.0.141",
        host = conf.host or "127.0.0.1",
        port = conf.port or 3000,
    }
    if conf.start_neovim then
        local dap_run = dap.run
        dap.run = function(c)
            adapter.port = c.port
            adapter.host = c.host
        end
        require("osv").run_this()
        dap.run = dap_run
    end
    callback(adapter)
end

dap.configurations.lua = {
    {
        name = "Current file",
        type = "nlua",
        request = "attach",
        verbose = true,
        start_neovim = {},
    },
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
        port = 3000,
    },
}
map_desc("n", "<leader>dL", function()
    require("osv").launch({ port = 3000 })
end, "Launch DAP server (osv)")
