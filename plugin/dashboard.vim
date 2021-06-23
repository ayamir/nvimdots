" Dashboard
let g:mapleader=","
let g:dashboard_session_directory = '~/.nvim/session'
let g:dashboard_default_executive ='telescope'
let g:indentLine_fileTypeExclude = ['dashboard']
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2
let g:dashboard_preview_command = 'cat'
let g:dashboard_preview_file = '~/.config/nvim/ayanami.cat'
let g:dashboard_preview_file_height = 17
let g:dashboard_preview_file_width = 37


nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fr :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>

let g:dashboard_custom_shortcut={
			\ 'last_session'       : 'comma s l',
			\ 'find_history'       : 'comma f r',
			\ 'find_file'          : 'comma f f',
			\ 'new_file'           : 'comma c n',
			\ 'change_colorscheme' : 'comma t c',
			\ 'find_word'          : 'comma f a',
			\ 'book_marks'         : 'comma f b',
			\ }


