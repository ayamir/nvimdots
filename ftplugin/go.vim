augroup gosettings
autocmd!
autocmd FileType go nmap <leader>mbb <Plug>(go-build)
autocmd FileType go nmap <leader>mbr <Plug>(go-run)
autocmd FileType go nmap <leader>mds :GoDebugStart<cr>
autocmd FileType go nmap <leader>mdb :GoDebugBreakpoint<cr>
autocmd FileType go nmap <leader>mdc :GoDebugContinue<cr>
autocmd FileType go nmap <leader>mdo :GoDebugStepOut<cr>
autocmd FileType go nmap <leader>mdt :GoDebugStop<cr>
augroup END
