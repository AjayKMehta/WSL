local map_desc = require("utils.mappings").map_desc

local dap = require("dap")
-- https://www.lazyvim.org/extras/dap/nlua
dap.adapters.nlua = function(callback, conf)
    callback({ type = 'server', host = conf.host or "127.0.0.1", port = conf.port or 3000 })
end

dap.configurations.lua = {
    {
        name = "Current file",
        type = "nlua",
        request = "attach",
        verbose = true,
    },
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
        port = 3000,
    }
}
map_desc("n", "<leader>dL", function()
    require("osv").launch({ port = 3000 })
end, "Launch DAP server (osv)")
