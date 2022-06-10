local prettier = function()
  return { exe = 'prettierd', args = { vim.api.nvim_buf_get_name(0) }, stdin = true }
end

local isort = function()
  return { exe = 'isort', args = { '-' }, stdin = true }
end

local black = function()
  return { exe = 'black', args = { '-' }, stdin = true }
end

local xmllint = function()
  return { exe = 'xmllint', args = { '--format', '-' }, stdin = true }
end

local stylua = function()
  return { exe = 'stylua', args = { '-' }, stdin = true }
end

require('formatter').setup({
  logging = false,
  filetype = {
    typescript = { prettier },
    typescriptreact = { prettier },
    javascript = { prettier },
    javascriptreact = { prettier },
    css = { prettier },
    vue = { prettier },
    lua = { stylua },
    less = { prettier },
    json = { prettier },
    yaml = { prettier },
    markdown = { prettier },
    html = { prettier },
    python = { isort, black },
    scala = {prettier},
    xml = { xmllint },
    svg = { xmllint },
    toml = { prettier },
  },
})

local files = {
  '*.css',
  '*.graphql',
  '*.html',
  '*.js',
  '*.json',
  '*.jsx',
  '*.less',
  '*.lua',
  '*.markdown',
  '*.md',
  '*.mjs',
  '*.py',
  '*.scala',
  '*.scss',
  '*.svg',
  '*.toml',
  '*.ts',
  '*.tsx',
  '*.vue',
  '*.xml',
  '*.yaml',
  '*.yml',
}

local pattern = table.concat(files, ',')
local group = vim.api.nvim_create_augroup('Formatter', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = pattern,
  command = 'FormatWrite',
  group = group,
})
