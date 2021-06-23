require'nvim-treesitter.configs'.setup {
ensure_installed = { "c", "cpp", "go", "gomod", "rust", "bash", "lua" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
ignore_install = { "javascript", "beancount", "bibtex", "c_sharp", "clojure", "comment", "commonlisp", "cuda", "dart", "devicetree", "elixir", "erlang", "fennel", "Godot", "glimmer", "graphql", "java", "jsdoc", "julia", "kotlin", "ledger", "nix", "ocaml", "ocaml_interface", "php", "ql", "query", "r", "rst", "ruby", "scss", "sparql", "supercollider", "svelte", "teal", "tsx", "typescript", "turtle", "verilog", "vue", "zig" }, -- List of parsers to ignore installing
highlight = {
enable = true,              -- false will disable the whole extension
disable = {  },  -- list of language that will be disabled
},
}
