-- vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach({})]])
Metals_config = require('metals').bare_config()
Metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  }
}

-- metals_config.on_attach = function()
--   require'completion'.on_attach();
-- end

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

Metals_config.capabilities = capabilities

-- require("metals").initialize_or_attach(metals_config)

local dap = require("dap")
dap.defaults.fallback.force_external_terminal = true

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run",
    metals = {
      runType = "run",
      -- args = { "firstArg", "secondArg", "thirdArg" },
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test File",
    metals = {
      runType = "testFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

Metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

local cmd = vim.cmd
-- LSP
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]])
cmd([[augroup end]])

-- Need for symbol highlights to work correctly
cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])

-- telescope extension
-- require("telescope").extensions.metals.commands()
-- Keybinding
vim.api.nvim_set_keymap(
  "n",
  "<Leader>mt",
  ":lua require('telescope').extensions.metals.commands()<CR>",
  { noremap = true }
)
