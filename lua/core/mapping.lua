local bind = require('keymap.bind')
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

-- default map
local def_map = {
    -- Vim map
    ["n|<C-x>k"] = map_cr('bdelete'):with_noremap():with_silent(),
    ["n|<C-s>"] = map_cu('write'):with_noremap(),
    ["n|Y"] = map_cmd('y$'),
    ["n|]w"] = map_cu('WhitespaceNext'):with_noremap(),
    ["n|[w"] = map_cu('WhitespacePrev'):with_noremap(),
    ["n|<Space>cw"] = map_cu([[silent! keeppatterns %substitute/\s\+$//e]]):with_noremap()
        :with_silent(),
    ["n|<C-h>"] = map_cmd('<C-w>h'):with_noremap(),
    ["n|<C-l>"] = map_cmd('<C-w>l'):with_noremap(),
    ["n|<C-j>"] = map_cmd('<C-w>j'):with_noremap(),
    ["n|<C-k>"] = map_cmd('<C-w>k'):with_noremap(),
    ["n|<A-[>"] = map_cr('vertical resize -5'):with_silent(),
    ["n|<A-]>"] = map_cr('vertical resize +5'):with_silent(),
    ["n|<C-q>"] = map_cmd(':wq<CR>'),
    ["n|<A-q>"] = map_cmd(':bw<CR>'),
    ["n|<A-S-q>"] = map_cmd(':bw!<CR>'),
    ["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"),
    -- Insert
    ["i|<C-w>"] = map_cmd('<C-[>diwa'):with_noremap(),
    ["i|<C-h>"] = map_cmd('<BS>'):with_noremap(),
    ["i|<C-u>"] = map_cmd('<C-G>u<C-U>'):with_noremap(),
    ["i|<C-b>"] = map_cmd('<Left>'):with_noremap(),
    ["i|<C-a>"] = map_cmd('<ESC>^i'):with_noremap(),
    ["i|<C-j>"] = map_cmd('<Esc>o'):with_noremap(),
    ["i|<C-k>"] = map_cmd('<Esc>O'):with_noremap(),
    ["i|<C-s>"] = map_cmd('<Esc>:w<CR>'),
    ["i|<C-q>"] = map_cmd('<Esc>:wq<CR>'),
    -- command line
    ["c|<C-b>"] = map_cmd('<Left>'):with_noremap(),
    ["c|<C-f>"] = map_cmd('<Right>'):with_noremap(),
    ["c|<C-a>"] = map_cmd('<Home>'):with_noremap(),
    ["c|<C-e>"] = map_cmd('<End>'):with_noremap(),
    ["c|<C-d>"] = map_cmd('<Del>'):with_noremap(),
    ["c|<C-h>"] = map_cmd('<BS>'):with_noremap(),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),
    ["c|w!!"] = map_cmd(
        "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")
}

bind.nvim_load_mapping(def_map)
