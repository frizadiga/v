local M = {}

function M.complete_filetype(arglead)
  return vim.fn.getcompletion(arglead, 'filetype')
end

function M.set_filetype(opts)
  local filetype = opts.fargs[1]
  if filetype == '' then
    print('No filetype provided')
    return
  end

  vim.bo.filetype = filetype
  print('Filetype set to: ' .. filetype)
end

return M
