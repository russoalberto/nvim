local M = {}
local utils = require("langs.csharp.utils")

local function handle(response, buffer)
  if response.err ~= nil then
    return
  end

  if vim.tbl_isempty(response.result.Changes) then
    return
  end

  local text_edits = utils.omnisharp_text_changes_to_text_edits(response.result.Changes)
  vim.lsp.util.apply_text_edits(text_edits, buffer, "utf-8")
end

function M.execute(buffer)
  local omnisharp_client = utils.get_omnisharp_client(buffer)

  if omnisharp_client == nil then
    return
  end

  local position_params = vim.lsp.util.make_position_params(0, "utf-8")

  local request = {
    Column = position_params.position.character,
    Line = position_params.position.line,
    FileName = vim.uri_to_fname(position_params.textDocument.uri),
    WantsTextChanges = true,
    ApplyTextChanges = false,
  }

  local response = omnisharp_client.request_sync("o#/fixusings", request, 2000, buffer)
  handle(response, buffer)
end

return M
