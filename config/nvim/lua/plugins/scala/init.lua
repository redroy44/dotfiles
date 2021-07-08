metals_config = require'metals'.bare_config
metals_config.settings = {
   showImplicitArguments = true,
   showInferredType = true,
   excludedPackages = {
     "akka.actor.typed.javadsl",
     "com.github.swagger.akka.javadsl"
   }
}
metals_config.init_options.statusBarProvider = "on"

-- metals_config.on_attach = function()
--   require'completion'.on_attach();
-- end

metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = '',
    }
  }
)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

metals_config.capabilities = capabilities

require("metals").initialize_or_attach(metals_config)

local cmd = vim.cmd
-- LSP
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
cmd([[augroup end]])

-- Need for symbol highlights to work correctly
vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])

-- telescope extension
-- require("telescope").extensions.metals.commands()
-- Keybinding
vim.api.nvim_set_keymap(
  "n",
  "<Leader>mt",
  ":lua require('telescope').extensions.metals.commands()<CR>",
  {noremap = true}
)
