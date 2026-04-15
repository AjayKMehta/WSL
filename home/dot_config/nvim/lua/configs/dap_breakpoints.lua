local map_desc = require("utils.mappings").map_desc


require("dap-breakpoints").setup()

local dapbp_api = require("dap-breakpoints.api")

map_desc("n", "<leader>dth", dapbp_api.set_hit_condition_breakpoint, "Set Hit Condition Breakpoint")

map_desc("n", "<leader>dtL", function()
    dapbp_api.load_breakpoints({ notify = "on_some" })
end, "Load Breakpoints")

map_desc("n", "<leader>dtS", function()
    dapbp_api.save_breakpoints({ notify = "on_some" })
end, "Save Breakpoints")

map_desc("n", "<leader>dte", dapbp_api.edit_property, "Edit Breakpoint Property")

map_desc("n", "<leader>dtv", dapbp_api.toggle_virtual_text, "Toggle Breakpoint Virtual Text")

map_desc("n", "[,", dapbp_api.go_to_previous, "Go to Previous Breakpoint")

map_desc("n", "],", dapbp_api.go_to_next, "Go to Next Breakpoint")

map_desc("n", "<leader>def", dapbp_api.edit_exception_filters, "Edit Exception Breakpoint Filters")
