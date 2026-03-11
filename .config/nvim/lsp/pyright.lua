local pixi = require('utils.pixi')

return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pixi.toml',
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  on_attach = function(client, bufnr)
    local root = pixi.find_pixi_root(bufnr)
    if not root then return end

    local python_path, site_packages = pixi.get_pixi_python_info(root)
    if not python_path then return end
    
    client.settings.python = vim.tbl_deep_extend(
      'force',
      client.settings.python or {}, {
        pythonPath = python_path,
        analysis = { extraPaths = site_packages and { site_packages } or {} }
    })

    client.notify('workspace/didChangeConfiguration', { settings = nil })
  end,
}
