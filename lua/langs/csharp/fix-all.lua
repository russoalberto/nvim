local M = {}
local utils = require("langs.csharp.utils")

M.scope = {
  Document = 0,
  Project = 1,
  Solution = 2,
}

local function handle_run_fix_all(error, response)
  local workspace_edits = { changes = {} }

  for _, change in pairs(response.Changes) do
    if change.ModificationType ~= 0 then
      goto continue
    end

    local file_uri = vim.uri_from_fname(change.FileName)
    local text_edits = utils.omnisharp_text_changes_to_text_edits(change.Changes)
    workspace_edits.changes[file_uri] = text_edits

    ::continue::
  end

  vim.lsp.util.apply_workspace_edit(workspace_edits, "utf-8")
end

local function run_fix_all(client_id, buffer, params)
  local omnisharp_client = vim.lsp.get_client_by_id(client_id)

  local request = {
    FileName = params.fileName,
    Scope = params.scope,
    FixAllFilter = params.items,
    WantsAllCodeActionOperations = true,
    WantsTextChanges = true,
    ApplyChanges = false,
    Timeout = 2000,
  }

  omnisharp_client.request("o#/runfixall", request, handle_run_fix_all, buffer)
end

local function handle_get_fix_all(error, response, ctx)
  if (response == nil) then
    print("No fix found")
    return;
  end
  vim.ui.select(response.Items, {
    prompt = "Fix All:",
    format_item = function(item)
      return item.Id .. ": " .. item.Message
    end,
  }, function(choice)
    local params = { items = { choice }, scope = ctx.params.Scope, fileName = ctx.params.FileName }
    run_fix_all(ctx.client_id, ctx.bufnr, params)
  end)
end

function M.execute(buffer, params)
  if not M.scope[params.scope] then
    return
  end

  local omnisharp_client = utils.get_omnisharp_client(buffer)

  if omnisharp_client == nil then
    return
  end

  local position_params = vim.lsp.util.make_position_params(1000, "utf-8")

  local request = {
    Column = position_params.position.character,
    Line = position_params.position.line,
    FileName = vim.uri_to_fname(position_params.textDocument.uri),
    Scope = params.scope,
  }

  omnisharp_client.request("o#/getfixall", request, handle_get_fix_all, buffer)
end

function M.select_scope_and_execute(buffer)
  vim.ui.select({ "Document", "Project", "Solution" }, { prompt = "Fix All:" }, function(selected)
    if selected then
      M.execute(buffer, { scope = selected })
    end
  end)
end

return M
