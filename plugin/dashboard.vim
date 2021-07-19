" Dashboard
let g:mapleader=","
let g:dashboard_footer_icon = '🐬 '
" You need to change here(use absolute path)
let g:dashboard_session_directory = '/home/ayamir/.nvim/session'
let g:dashboard_default_executive ='telescope'
let g:indentLine_fileTypeExclude = ['dashboard']
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2
let g:dashboard_preview_pipeline = 'lolcat -F 0.2 --truecolor -f'
let g:dashboard_preview_command = 'cat'
let g:dashboard_preview_file = '~/.config/nvim/ayanami.cat'
let g:dashboard_preview_file_height = 17
let g:dashboard_preview_file_width = 37

nnoremap <silent> <Leader>fp :lua require'telescope'.extensions.project.project{}<CR>
nnoremap <silent> <Leader>fr :DashboardFindHistory<CR>
nnoremap <silent> <Leader>fc :Telescope frecency<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fw :DashboardFindWord<CR>
nnoremap <silent> <Leader>fn :DashboardNewFile<CR>

let g:dashboard_custom_section={
      \ 'change_colorscheme': {
        \ 'description': [ ' Scheme change              comma t c '],
        \ 'command': 'DashboardChangeColorscheme', },
        \ 'find_history': {
          \ 'description': [' File history               comma f r'],
          \ 'command': 'DashboardFindHistory', },
          \ 'find_frecency': {
            \ 'description': [ '祥File frecency              comma f c '],
            \ 'command': 'Telescope frecency', },
            \ 'find_file': {
              \ 'description': [ ' File find                  comma f f '],
              \ 'command': 'DashboardFindFile', },
              \ 'file_new': {
                \ 'description': [ ' File new                   comma f n '],
                \ 'command': 'DashboardNewFile', },
                \ 'find_word': {
                  \ 'description': [ ' Word find                  comma f w '],
                  \ 'command': 'DashboardFindWord', },
                  \ 'find_project': {
                    \ 'description': [ ' Project find               comma f p '],
                    \ 'command': "lua require'telescope'.extensions.project.project{}", },
                    \}
