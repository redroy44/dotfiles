local lsp_installer = require('nvim-lsp-installer')

local servers = {
  'cssls',
  'jsonls',
  'yamlls',
  -- 'taplo',
  'pyright',
  'lua_ls',
  'emmet_ls',
  'tsserver',
  'esbonio',
  'dockerls',
  'terraformls',
  'sqlls'
}

lsp_installer.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

for _, name in ipairs(servers) do
  -- Specify the default options which we'll use to setup all servers
  local default_opts = require('lsp.opts')

  -- Enhance the default opts with the server-specific ones
  pcall(function()
    require('lsp.servers.' .. name).setup(default_opts)
  end)

  require('lspconfig')[name].setup(default_opts)
end

-- Diagnostic icons
local signs = {
  Error = ' ',
  Warn = ' ',
  Hint = '硫',
  Info = ' ',
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end
