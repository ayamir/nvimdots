" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

let g:neoformat_try_formatprg = 1

let g:neoformat_only_msg_on_error = 1

let g:neoformat_run_all_formatters = 1

let g:shfmt_opt="-ci"

let g:neoformat_enabled_c = ['clang-format']
let g:neoformat_enabled_cpp = ['clang-format']
let g:neoformat_enabled_cmake = ['cmake_format']
let g:neoformat_enabled_go = ['gofmt', 'goimports']
let g:neoformat_enabled_python = ['autopep8', 'yapf']
let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_shell = ['shfmt']
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_enabled_html = ['html-beautify']
