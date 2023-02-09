nnoremap <silent> <buffer> <leader>ct :lua require("craates").toggle()<CR>
nnoremap <silent> <buffer> <leader>cr :lua require("crates").reload()<CR>

nnoremap <silent> <buffer> <leader>cs :lua require("crates").show_popup()<CR>
nnoremap <silent> <buffer> <leader>cv :lua require("crates").show_versions_popup(); require("crates").show_popup()<CR>
nnoremap <silent> <buffer> <leader>cf :lua require("crates").show_features_popup(); require("crates").show_popup()<CR>
nnoremap <silent> <buffer> <leader>cd :lua require("crates").show_dependencies_popup(); require("crates").show_popup()<CR>

nnoremap <silent> <buffer> <leader>cu :lua require("crates").update_crate()<CR>
vnoremap <silent> <buffer> <leader>cu :lua require("crates").update_crates()<CR>
nnoremap <silent> <buffer> <leader>ca :lua require("crates").update_all_crates()<CR>
nnoremap <silent> <buffer> <leader>cU :lua require("crates").upgrade_crate()<CR>
vnoremap <silent> <buffer> <leader>cU :lua require("crates").upgrade_crates()<CR>
nnoremap <silent> <buffer> <leader>cA :lua require("crates").upgrade_all_crates()<CR>

nnoremap <silent> <buffer> <leader>cH :lua require("crates").open_homepage()<CR>
nnoremap <silent> <buffer> <leader>cR :lua require("crates").open_repository()<CR>
nnoremap <silent> <buffer> <leader>cD :lua require("crates").open_documentation()<CR>
nnoremap <silent> <buffer> <leader>cC :lua require("crates").open_crates_io()<CR>
