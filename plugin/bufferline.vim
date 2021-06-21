lua << EOF
require "bufferline".setup {
	options = {
		number = "none",
		number_style = "superscript",
		offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center", padding = 1}},
		buffer_close_icon = "",
		modified_icon = "",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 20,
		show_tab_indicators = true,
		diagnostics = "nvim_lsp",
	enforce_regular_tabs = false,
	view = "multiwindow",
	show_buffer_close_icons = true,
	always_show_bufferline = true,
	separator_style = "thin",
	mappings = "true"
	}
}
EOF

noremap <A-j> :BufferLineCycleNext<cr>
noremap <A-k> :BufferLineCyclePrev<cr>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent><mymap> :BufferLineMoveNext<CR>
nnoremap <silent><mymap> :BufferLineMovePrev<CR>

" These commands will sort buffers by directory, language, or a custom criteria
nnoremap <silent><leader>be :BufferLineSortByExtension<CR>
nnoremap <silent><leader>bd :BufferLineSortByDirectory<CR>
nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>


