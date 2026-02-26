local fixAll = require("utils.csharp.fix-all")
local fixUsings = require("utils.csharp.fix-usings")

local M = {}

function M.create_fix_usings_command(buffer)
  vim.api.nvim_buf_create_user_command(buffer, "CsharpFixUsings",
    function() fixUsings.execute(buffer) end, { desc = "Csharp: Remove unneccessary usings" })
end

function M.create_fix_all_command(buffer)
  vim.api.nvim_buf_create_user_command(buffer, "CsharpFixAll",
    function() fixAll.select_scope_and_execute(buffer) end, { desc = "Csharp: Fix all" })
end

return M
