local terraformls = {}

terraformls.setup = function(opts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true 

  require('lspconfig').terraformls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
  })
end

return terraformls
