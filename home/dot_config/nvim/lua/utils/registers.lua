local M = {}

-- Basic implementation
M.get_first_empty_register = function ()
    for reg = 97, 122 do -- ASCII codes for 'a' to 'z'
        local register_name = string.char(reg)
        local content = vim.fn.getreg(register_name)

        -- Check if register is empty
        if content == "" or content == nil then
            return register_name
        end
    end

    return nil
end

-- Enhanced version with more functionality
M.get_first_empty_register_with_options = function (options)
    options = options or {}
    local start_reg = options.start or "a"
    local end_reg = options.end_reg or "z"

    -- Convert register letters to ASCII range
    local start_ascii = string.byte(start_reg:lower())
    local end_ascii = string.byte(end_reg:lower())

    -- Iterate through specified range
    for reg = start_ascii, end_ascii do
        local register_name = string.char(reg)
        local content = vim.fn.getreg(register_name)

        if content == "" or content == nil then
            return register_name
        end
    end

    return nil
end

M.clear_register = function(reg)
    vim.cmd(":let @" .. reg .. '=""')
end

return M
