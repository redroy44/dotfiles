local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  completion = { autocomplete = false, completeopt = 'menu,menuone,noinsert' },
  window = {
    completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' }),
    ["<Down>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, {"i","s","c",}),
    ["<Up>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {"i","s","c",}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  },

  formatting = {
    format = function(entry, vim_item)
      -- set a name for each source
      vim_item.menu = ({
        cmp_git = '[git]',
        nvim_lsp = ' [lsp]',
        nvim_lua = '[lua]',
        vsnip = ' [snip]',
        path = '[path] ',
        buffer = '[buff] ',
        spell = '[spell]',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lua' },
    { name = 'cmp_git' },
    { name = 'nvim_lsp', priority = 10 },
    { name = 'vsnip' },
    { name = 'treesitter' },
    { name = 'path' },
    { name = 'spell' },
    { name = 'buffer', keyword_length = 5 },
  },
  experimental = { ghost_text = true },
})

require('cmp_git').setup({ filetypes = { 'gitcommit', 'markdown' } })
