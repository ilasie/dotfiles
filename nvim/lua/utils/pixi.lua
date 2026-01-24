local M = {}

function M.find_pixi_root(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then return nil end
  
  local matches = vim.fs.find('pixi.toml', { upward = true, path = bufname })
  local root = #matches > 0 and vim.fs.dirname(matches[1]) or
    vim.fs.dirname(bufname)

  return root
end

function M.get_pixi_python_info(root)
  local cmd = string.format(
    "cd %s && pixi run python -c 'import sys; import sysconfig; print(sys.executable); print(sysconfig.get_path(\"purelib\"))' 2>/dev/null",
    vim.fn.shellescape(root)
  )
  local handle = io.popen(cmd)
  if not handle then return nil, nil end

  local python_path = handle:read('*l')
  local site_packages = handle:read('*l')
  handle:close()

  if not python_path or not site_packages then
    return nil, nil
  end

  return python_path, site_packages
end

return M
