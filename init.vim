lua require("core")

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件列表
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""call plug#begin('~/.local/share/nvim/plugged')
""
""Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
""Plug 'christoomey/vim-tmux-navigator'
""Plug 'tmux-plugins/vim-tmux'
""Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
""Plug 'junegunn/fzf.vim'
""Plug 'szw/vim-maximizer'
""Plug 'inkarkat/vim-ingo-library'
""Plug 'inkarkat/vim-mark'
""call plug#end()

" 自动检查并安装缺失的插件
""autocmd VimEnter *
 ""        PlugInstall | q
""augroup END
""augroup PlugAutoCmdGroup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = " "      " 定义<leader>键
let maplocalleader = "\\"      " 定义<localleader>键

" set nocompatible         " 设置不兼容原始vi模式
filetype on              " 设置开启文件类型侦测
filetype plugin on       " 设置加载对应文件类型的插件
set noeb                 " 关闭错误的提示
syntax enable            " 开启语法高亮功能
syntax on                " 自动语法高亮
set t_Co=256             " 开启256色支持
set cmdheight=2          " 设置命令行的高度
set showcmd              " select模式下显示选中的行数
set ruler                " 总是显示光标位置
set laststatus=2         " 总是显示状态栏
set number               " 开启行号显示
set cursorline           " 高亮显示当前行
set whichwrap+=<,>,h,l   " 设置光标键跨行
set ttimeoutlen=0        " 设置<ESC>键响应时间
set virtualedit=block,onemore   " 允许光标出现在最后一个字符的后面
set norelativenumber     " 相对行号
set mouse=a              " 开启鼠标
set cursorcolumn         " 设置光标所在列高亮
highlight CursorColumn guibg=#66ff66
highlight cursorline guibg=#66ff66
set colorcolumn=72

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码缩进和排版
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent           " 设置自动缩进
set cindent              " 设置使用C/C++语言的自动缩进方式
set cinoptions=g0,:0,N-s,(0    " 设置C/C++语言的具体缩进方式
set smartindent          " 智能的选择对其方式
filetype indent on       " 自适应不同语言的智能缩进
set noexpandtab            " 将制表符扩展为空格
set tabstop=8            " 设置编辑时制表符占用空格数
set shiftwidth=8         " 设置格式化时制表符占用空格数
set softtabstop=8        " 设置4个空格为制表符
set smarttab             " 在行和段开始处使用制表符
set backspace=2          " 使用回车键正常处理indent,eol,start等
set sidescroll=10        " 设置向右滚动字符数
set nofoldenable         " 禁用折叠代码
" indentLine 开启代码对齐线
let g:indentLine_enabled = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码补全
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu             " vim自身命名行模式智能补全
set completeopt-=preview " 补全时不显示窗口，只显示补全列表

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch            " 高亮显示搜索结果
set incsearch           " 开启实时搜索功能
set ignorecase          " 搜索时大小写不敏感

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 缓存设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup            " 设置不备份
set noswapfile          " 禁止生成临时文件
set autoread            " 文件在vim之外修改过，自动重新读入
set autowrite           " 设置自动保存
set confirm             " 在处理未保存或只读文件的时候，弹出确认
set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编码设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=zh_CN.UTF-8
set helplang=cn
" set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

" 编辑vimrc相关配置文件
nnoremap <leader>e :edit ~/.config/nvim/init.vim<cr>


" 安装、更新、删除插件
nnoremap <leader><leader>i :PlugInstall<cr>
nnoremap <leader><leader>u :PlugUpdate<cr>
" nnoremap <leader><leader>c :PlugClean<cr>

" 分屏窗口移动
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" 复制当前选中到系统剪切板
vmap <leader><leader>y "+y

" 将系统剪切板内容粘贴到vim
nnoremap <leader><leader>p "+p

" vim-easymotion
let g:EasyMotion_smartcase = 1


" LeaderF
"nnoremap <leader>f :LeaderfFile .<cr>
let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg','.vscode','.wine','.deepinwine','.oh-my-zsh'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \}
let g:Lf_UseCache = 0
" Leaderf Settings
let g:Lf_DefaultMode = "NameOnly"
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" Show icons, icons are shown by default
let g:Lf_ShowDevIcons = 1
" For GUI vim, the icon font can be specify like this, for example
let g:Lf_DevIconsFont = "DroidSansM Nerd Font Mono"
let g:Lf_QuickSelect = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

unmap <leader>f
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>fb'
"" for vim-mark
unmap <Leader>n
nmap <Leader>M <Plug>MarkToggle
nmap <Leader>N <Plug>MarkAllClear
nmap <Leader>mc <Plug>MarkClear
noremap <localleader>ff :<C-U><C-R>=printf("LeaderfFile %s", "")<CR><CR>
noremap <localleader>f. :<C-U><C-R>=printf("LeaderfFile ./ %s", "")<CR><CR>
noremap <localleader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <localleader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <localleader>ft :<C-U><C-R>=printf("LeaderfBufTagAll %s", "")<CR><CR>
noremap <localleader>fc :<C-U><C-R>=printf("Leaderf cmdHistory %s", "")<CR><CR>
noremap <localleader>fs :<C-U><C-R>=printf("Leaderf searchHistory %s", "")<CR><CR>
noremap <localleader>fa :<C-U><C-R>=printf("Leaderf! rg --all-buffers %s",  expand("<cword>"))<CR><CR>
noremap <localleader>fg :<C-U><C-R>=printf("Leaderf! rg -g \"*.c\" -g \"*.h\" -g \"*.cpp\"  %s",  expand("<cword>"))<CR><CR>
noremap <localleader>fr :<C-U><C-R>=printf("LeaderfRgInteractive %s", "")<CR><CR>
noremap <localleader>fo :<C-U>Leaderf! rg --recall<CR>

noremap <localleader>mt <Plug>RenderMarkdown toggle
noremap <localleader>mv :RenderMarkdown preview <CR>

noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>zz
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" should use `Leaderf gtags --update` first
noremap <localleader>lfu :Leaderf gtags --update<CR>
noremap <localleader>lfh :LeaderfHistoryCmd<CR>
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_GtagsAutoUpdate = 1
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>gr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>gb :<C-U><C-R>=printf("Leaderf! gtags --by-context --auto-jump %s", expand("<cword>"))<CR><CR>
noremap <leader>gd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>gg :<C-U><C-R>=printf("Leaderf! gtags -g %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>gs :<C-U><C-R>=printf("Leaderf! gtags -s %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>go :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>gn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>gp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

autocmd BufRead,BufNewFile *.py,*.js,*.html,*.css,*.c,*.h call CreateCtags()
function! CreateCtags()
    " 检测是否存在 ctags 命令
    if !executable('ctags')
        echo "ctags is not installed or not in the PATH"
        return
    endif

    " 检测当前目录下是否存在 ctags 文件
    if ((filereadable('.tags') || filereadable('../.tags') || filereadable('../../.tags') || filereadable('../../../.tags')) && !(filereadable('tags') || filereadable('../tags') || filereadable('../../tags') || filereadable('../../../tags') || filereadable('../../../../tags')))
	" 使用 ctags 命令生成 tags 文件
	let l:git_root = system('git rev-parse --show-toplevel')
	if l:git_root =~ 'Not\ a\ git\ repository'
		echo "Not a git repository, Generating ctags file in pwd..."
		silent! AsyncRun '!ctags -a -R --exclude=.git --exclude=log .'
	else
		echo "Is a git repository, Generating ctags file in git root dir..."
		:lcd `=l:git_root`
		silent! AsyncRun '!ctags -a -R --exclude=.git --exclude=log `=l:git_root`'
	endif
    endif
endfunction

" Tmux settings
let g:tmux_navigator_no_mappings = 1

noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>

"系统剪贴板同步
" 自定义剪贴板提供者（修复 tmux 中的 DISPLAY 问题）
let g:clipboard = {
      \   'name': 'xsel-tmux-fix',
      \   'copy': {
      \      '+': ['sh', '-c', 'DISPLAY=:0 xsel -i -b'],
      \      '*': ['sh', '-c', 'DISPLAY=:0 xsel -i -p'],
      \    },
      \   'paste': {
      \      '+': ['sh', '-c', 'DISPLAY=:0 xsel -o -b'],
      \      '*': ['sh', '-c', 'DISPLAY=:0 xsel -o -p'],
      \   },
      \   'cache_enabled': 1,
      \ }
set clipboard=unnamedplus
" 支持在Visual模式下，通过C-y复制到系统剪切板
vnoremap <C-y> "+y
" 支持在normal模式下，通过A-p粘贴系统剪切板  shift+insert
nnoremap <A-p> "*p
inoremap <A-p> "*p

inoremap <A-h> <Right>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>
inoremap <A-b> <ESC>I
inoremap <A-e> <ESC>A


inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

noremap <C-j> 9j
noremap <C-k> 9k

""nnoremap y "+y
""vnoremap y "+y

nmap <leader><leader>s :w<cr>
nmap <leader>q :bd<cr>
nmap <leader>x :qa<cr>
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>
inoremap jj <Esc>

nmap gb :Git blame<cr>
nmap <leader>v <cmd>AerialToggle!<CR>

" 禁用悬浮窗口,已经在lua/user/keymap/core.lua 中配置
" autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})

" fzf
" Initialize configuration dictionary
let g:fzf_vim = {}
let g:fzf_vim.command_prefix = 'Fzf'
" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']

" Preview window is hidden by default. You can toggle it with ctrl-/.
" It will show on the right with 50% width, but if the width is smaller
" than 70 columns, it will show above the candidate list
let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']

" Empty value to disable preview window altogether
let g:fzf_vim.preview_window = []

" fzf.vim needs bash to display the preview window.
" On Windows, fzf.vim will first see if bash is in $PATH, then if
" Git bash (C:\Program Files\Git\bin\bash.exe) is available.
" If you want it to use a different bash, set this variable.
"   let g:fzf_vim = {}
"   let g:fzf_vim.preview_bash = 'C:\Git\bin\bash.exe

" [Buffers] Jump to the existing window if possible
let g:fzf_vim.buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_vim.commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_vim.tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_vim.commands_expect = 'alt-enter,ctrl-x'

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Using Lua functions
nnoremap <leader>ti <cmd>lua require('telescope.builtin').lsp_incoming_calls()<cr>
nnoremap <leader>to <cmd>lua require('telescope.builtin').lsp_outgoing_calls()<cr>
nnoremap <leader>tsd <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>tsw <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
nnoremap <leader>tsa <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>
nnoremap <leader>tsb <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
nnoremap <leader>td <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>tr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>tm <cmd>lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap <leader>th <cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>
nnoremap <leader>ta <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>tgg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>tgw <cmd>lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()<cr>
nnoremap <leader>tgb <cmd>lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor_current_buffer()<cr>
nnoremap <leader>tgv <cmd>lua require("telescope-live-grep-args.shortcuts").grep_visual_selection()<cr>

nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fj <cmd>lua require('telescope.builtin').jumplist()<cr>
nnoremap <leader>fm <cmd>lua require('telescope.builtin').marks()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <silent> <leader>ft  :Telescope ctags_outline buf=all<CR>
set wrap
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

nnoremap <silent><C-w>m :vertical resize 80<CR>

" set
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
