require("nvim-treesitter.configs").setup {
  autotag = {
    enable = true
  },
  ensure_installed = {"python", "scala", "java"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {"dart"}
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  indent = {enable = true},
  context_commentstring = {
    enable = true
  }
}

require'nvim-treesitter.install'.compilers = { "clang" }
