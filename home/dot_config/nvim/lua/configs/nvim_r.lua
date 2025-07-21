-- https://github.com/jamespeapen/Nvim-R/wiki/Options
vim.g.Rout_more_colors = 1

local languages = { "r", "python" }
vim.g.markdown_fenced_languages = languages
vim.g.rmd_fenced_languages = languages
vim.g.R_non_r_compl = 0 -- use omni completion provided by another plugin

vim.g.R_set_omnifunc = {}

vim.g.R_assign = 0
vim.g.R_rconsole_width = 0 -- Always split horizontally
vim.g.R_auto_start = 1 -- Doesn't seem to work
vim.g.R_assign_map = "<M-->"
vim.g.R_rmd_environment = "new.env()" -- compile .Rmd in a fresh environment
vim.g.R_clear_line = 1 -- Delete existing stuff on command line before sending command to R
vim.g.R_openhtml = 1
vim.g.R_start_libs = "base,stats,graphics,grDevices,utils,methods,dplyr,data.table"
vim.g.R_csv_app = "terminal:vd"

-- https://github.com/jamespeapen/Nvim-R/wiki/Options#object-browser-options
vim.g.R_objbr_auto_start = 1
vim.g.R_objbr_opendf = 1 -- Show data.frame elements
vim.g.R_objbr_openlist = 1 -- Show list elements
vim.g.R_objbr_allnames = 1 -- Show hidden objects

if vim.g.use_radian then
    -- https://github.com/randy3k/radian/blob/master/README.md#nvim-r-support
    vim.g.R_app = "radian"
    vim.g.R_cmd = "R"
    vim.g.R_hl_term = 0
    vim.g.R_bracketed_paste = 1
end

require("cmp_nvim_r").setup({})

local create_command = function(cmd)
    vim.api.nvim_create_user_command(cmd, function(opts)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>" .. cmd, true, false, true), "t", false)
    end, {})
end
create_command("RSendLine")
create_command("RDSendLine")
create_command("RSendAboveLines")
create_command("RSendSelection")
create_command("RESendSelection")
create_command("RDSendSelection")
create_command("REDSendSelection")
create_command("RPlot")

create_command("RMakeRmd")
create_command("RMakeAll")
