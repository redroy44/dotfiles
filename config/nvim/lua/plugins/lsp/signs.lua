-- set default prefix.
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    -- virtual_text = false,
    virtual_text = {
      prefix = ""
    },
    signs = true,
    update_in_insert = false
  }
)

-- lsp diagnostics text
vim.fn.sign_define(
  "LspDiagnosticsSignError",
  {
    texthl = "LspDiagnosticsSignError",
    numhl = "LspDiagnosticsSignError",
    text = " "
  }
)
vim.fn.sign_define(
  "LspDiagnosticsSignWarning",
  {
    texthl = "LspDiagnosticsSignWarning",
    numhl = "LspDiagnosticsSignWarning",
    text = " "
  }
)
vim.fn.sign_define(
  "LspDiagnosticsSignHint",
  {
    texthl = "LspDiagnosticsSignHint",
    numhl = "LspDiagnosticsSignHint",
    text = " "
  }
)
vim.fn.sign_define(
  "LspDiagnosticsSignInformation",
  {
    texthl = "LspDiagnosticsSignInformation",
    numhl = "LspDiagnosticsSignInformation",
    text = " "
  }
)

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
  "   (Text) ",
  "   (Method)",
  "   (Function)",
  "   (Constructor)",
  " ﴲ  (Field)",
  "[] (Variable)",
  "   (Class)",
  " ﰮ  (Interface)",
  "   (Module)",
  " 襁 (Property)",
  "   (Unit)",
  "   (Value)",
  " 練 (Enum)",
  "   (Keyword)",
  "   (Snippet)",
  "   (Color)",
  "   (File)",
  "   (Reference)",
  "   (Folder)",
  "   (EnumMember)",
  " ﲀ  (Constant)",
  " ﳤ  (Struct)",
  "   (Event)",
  "   (Operator)",
  "   (TypeParameter)"
}
