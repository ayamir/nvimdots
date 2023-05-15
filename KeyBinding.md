The default **leader** key is `<Space>`.

|                          Effect                           |  Mode   |        Shortcut         |
| :-------------------------------------------------------: | :-----: | :---------------------: |
|              open vscode like command panel               |   `N`   |         `<C-p>`         |
|                       sync plugins                        |   `N`   |      `<leader>ps`       |
|                       clean plugins                       |   `N`   |      `<leader>px`       |
|                   check plugins update                    |   `N`   |      `<leader>pc`       |
|                     toggle nvim-tree                      |   `N`   |         `<C-n>`         |
|                     refresh nvim-tree                     |   `N`   |      `<leader>nr`       |
|                      toggle undotree                      |   `N`   |       `<leader>u`       |
|                       **Terminal**                        |         |                         |
|                 toggle vertical terminal                  |   `N`   |     `<A-\>`/`<F5>`      |
|                toggle horizontal terminal                 |   `N`   |         `<C-\>`         |
|                 toggle floating terminal                  |   `N`   |         `<A-d>`         |
|                       quit terminal                       |   `I`   |         `<C-d>`         |
|                   **Buffer navigation**                   |         |                         |
|               pick buffer `n`(`n`means No)                |   `N`   |         `<A-n>`         |
|                       right buffer                        |   `N`   |         `<A-j>`         |
|                        left buffer                        |   `N`   |         `<A-k>`         |
|               move current buffer to right                |   `N`   |        `<A-S-j>`        |
|                move current buffer to left                |   `N`   |        `<A-S-k>`        |
|                   close current buffer                    |   `N`   |         `<A-q>`         |
|                   close current window                    |   `N`   |        `<A-S-q>`        |
|                  split buffer vertically                  |   `N`   |        `<C-w>v`         |
|                 split buffer horizontally                 |   `N`   |        `<C-w>s`         |
|                       navigate down                       |   `N`   |         `<C-j>`         |
|                        navigate up                        |   `N`   |         `<C-k>`         |
|                       navigate left                       |   `N`   |         `<C-h>`         |
|                      navigate right                       |   `N`   |         `<C-l>`         |
|               **Operaions in `nvim-tree`**                |         |                         |
|                         new file                          |   `N`   |           `a`           |
|                   remove file/directory                   |   `N`   |           `d`           |
|                   rename file/directory                   |   `N`   |           `r`           |
|                      open directory                       |   `N`   |       `o`/`Enter`       |
|                      close directory                      |   `N`   |     `o`/`Backspace`     |
|                       copy filename                       |   `N`   |           `y`           |
|                    copy relative path                     |   `N`   |           `Y`           |
|                    copy absolute path                     |   `N`   |          `gy`           |
|           toggle file/directory begin with dot            |   `N`   |           `H`           |
|   toggle hidden file/directory configured in nvim-tree    |   `N`   |           `I`           |
|                 **Telescope Operations**                  |         |                         |
|               find file in recently opened                |   `N`   |      `<leader>fr`       |
|              find keyword in current project              |   `N`   |      `<leader>fw`       |
|               find file in current project                |   `N`   |      `<leader>ff`       |
|               find buffer in opened buffers               |   `N`   |      `<leader>fb`       |
|         search for the string under cursor in cwd         |   `N`   |      `<leader>fs`       |
|                   find file in history                    |   `N`   |      `<leader>fe`       |
|            find directory recorded by `zoxide`            |   `N`   |      `<leader>fz`       |
|                       find project                        |   `N`   |      `<leader>fp`       |
|                **Vanilla vim operations**                 |         |                         |
|                    escape insert mode                     |   `I`   |      `jk ` or `kj`      |
|        \[fold current\]/\[unfold collapsed\] block        |   `I`   |        `<S-Tab>`        |
|            Use `;` for `:`(Enter Command Mode)            |   `N`   |           `;`           |
|           **Lsp operations by `lspsaga.nvim`**            |         |                         |
|                     show code action                      |   `N`   |          `ga`           |
|                    preview definition                     |   `N`   |          `gd`           |
|                    jump to definition                     |   `N`   |          `gD`           |
|                  toggle tagbar(outline)                   |   `N`   |          `go`           |
|                lsp rename in current file                 |   `N`   |          `gr`           |
|                 rename in current project                 |   `N`   |          `gR`           |
|                    show signature help                    |   `N`   |          `gs`           |
| show current function/variable's definition or references |   `N`   |          `gh`           |
|      request incoming calls from the language server      |   `N`   |      `<leader>ci`       |
|      request outgoing calls from the language server      |   `N`   |      `<leader>co`       |
|                      show hover doc                       |   `N`   |           `K`           |
|           code diagnostics of the current line            |   `N`   |      `<leader>ld`       |
|            **Lsp operations by`trouble.nvim`**            |         |                         |
|                  toggle last diagnostics                  |   `N`   |          `gt`           |
|                   toggle lsp references                   |   `N`   |      `<leader>tr`       |
|              toggle lsp document diagnostics              |   `N`   |      `<leader>td`       |
|             toggle lsp workspace diagnostics              |   `N`   |      `<leader>tw`       |
|                   toggle code quickfix                    |   `N`   |      `<leader>tq`       |
|                    toggle code loclist                    |   `N`   |      `<leader>tl`       |
|                    **Code completion**                    |         |                         |
|                      next candidate                       |   `I`   |     `<Tab>`/`<C-n>`     |
|                      prev candidate                       |   `I`   |    `<S-Tab>`/`<C-p>`    |
|                     confirm candidate                     |   `I`   |        `<Enter>`        |
|                  close completion window                  |   `I`   |         `<C-w>`         |
|                  **Navigate in snippet**                  |         |                         |
|                   next snippet's block                    |   `I`   |         `<Tab>`         |
|                   prev snippet's block                    |   `I`   |        `<S-Tab>`        |
|             **Navigate in quote or bracket**              |         |                         |
|                     jump to quote end                     |   `I`   |         `<A-l>`         |
|                    back to quote begin                    |   `I`   |         `<A-h>`         |
|                    **Code selection**                     |         |                         |
|                 select current `()` block                 |   `N`   |          `vab`          |
|                 select current `{}` block                 |   `N`   |          `vaB`          |
|            select current outer function block            |   `N`   |          `vaf`          |
|             select current outer class block              |   `N`   |          `vac`          |
|            select current inner function block            |   `N`   |          `vif`          |
|             select current inner class block              |   `N`   |          `vic`          |
|                     **Code-snip Run**                     |         |                         |
|                Snip run for selected area                 |   `V`   |       `<leader>r`       |
|                  Snip run for whole file                  |   `N`   |       `<leader>r`       |
|                    **Cursor movement**                    |         |                         |
|                     jump to one line                      |   `N`   | `<leader>j`/`<leader>k` |
|                       find one word                       |   `N`   |       `<leader>w`       |
|                    find one character                     |   `N`   |       `<leader>c`       |
|             find two characters below cursor              |   `N`   |      `<leader>cc`       |
|         find one character`x` in front of cursor          |   `N`   |          `Fx`           |
|            find one character`x` behind cursor            |   `N`   |          `fx`           |
|          find next character`x` follow direction          |   `N`   |           `;`           |
|          find prev character`x` follow direction          |   `N`   |           `,`           |
|                    next function begin                    |   `N`   |          `][`           |
|                    prev function begin                    |   `N`   |          `[[`           |
|                     next function end                     |   `N`   |          `]]`           |
|                     prev function end                     |   `N`   |          `[]`           |
|                   next unstage git hunk                   |   `N`   |          `]g`           |
|                   prev unstage git hunk                   |   `N`   |          `[g`           |
|                   next code diagnostics                   |   `N`   |          `g]`           |
|                   prev code diagnostics                   |   `N`   |          `g[`           |
|                     **Code comment**                      |         |                         |
|                 toggle one line's comment                 |   `N`   |          `gcc`          |
|              toggle selected lines' comment               |   `V`   |          `gc`           |
|                   **Markdown preview**                    |         |                         |
|                  toggle MarkdownPreView                   |   `N`   |         `<F12>`         |
|                  **Session management**                   |         |                         |
|                   Save current session                    |   `N`   |      `<leader>ss`       |
|                   Restore last session                    |   `N`   |      `<leader>sr`       |
|                    Delete last session                    |   `N`   |      `<leader>sd`       |
|   **Debug mode(supports c&cpp&rustgolang&python now)**    |         |                         |
|                    Debug continue(run)                    |   `N`   |          `F6`           |
|                     Debug disconnect                      |   `N`   |          `F7`           |
|                  Debug toggle breakpoint                  |   `N`   |          `F8`           |
|                      Debug step into                      |   `N`   |          `F9`           |
|                      Debug step out                       |   `N`   |          `F10`          |
|                      Debug step over                      |   `N`   |          `F11`          |
|                      Debug run last                       |   `N`   |      `<leader>dl`       |
|                    Debug run to cursor                    |   `N`   |      `<leader>dc`       |
|            Debug set breakpoint with condition            |   `N`   |      `<leader>db`       |
|                      Debug open repl                      |   `N`   |      `<leader>do`       |
|                    **Git management**                     |         |                         |
|            open `lazygit` in current directory            |   `N`   |       `<leader>g`       |
|                    Enter vim-fugitive                     |   `N`   |       `<leader>G`       |
|                    Enter git diff view                    |   `N`   |       `<leader>D`       |
|                    Close git diff view                    |   `N`   |   `<leader><leader>D`   |
|                        Stage hunk                         | `N`/`V` |      `<leader>hs`       |
|                        Reset hunk                         | `N`/`V` |      `<leader>hr`       |
|                      Undo stage hunk                      |   `N`   |      `<leader>hu`       |
|                       Reset buffer                        |   `N`   |      `<leader>hR`       |
|                       Preview hunk                        |   `N`   |      `<leader>hp`       |
|                        Blame hunk                         |   `N`   |      `<leader>hb`       |
| **crates.io support _(Only available in `Cargo.toml`)_**  |         |                         |
|                  Toggle spec activities                   |   `N`   |      `<leader>ct`       |
|                    Reload crate specs                     |   `N`   |      `<leader>cr`       |
|                   Toggle pop-up window                    |   `N`   |      `<leader>cs`       |
|                   Select spec versions                    |   `N`   |      `<leader>cv`       |
|                   Select spec features                    |   `N`   |      `<leader>cf`       |
|                 Show project dependencies                 |   `N`   |      `<leader>cd`       |
|                Update current crate's spec                |   `N`   |      `<leader>cu`       |
|               Update selected crate's spec                |   `V`   |      `<leader>cu`       |
|                 Update all crates' specs                  |   `N`   |      `<leader>ca`       |
|                   Upgrade current crate                   |   `N`   |      `<leader>cU`       |
|                  Upgrade selected crates                  |   `V`   |      `<leader>cU`       |
|                    Upgrade all crates                     |   `N`   |      `<leader>cA`       |
|               Open current crate's homepage               |   `N`   |      `<leader>cH`       |
|              Open current crate's repository              |   `N`   |      `<leader>cR`       |
|            Open current crate's documentation             |   `N`   |      `<leader>cD`       |
|            Browse current crate on `crates.io`            |   `N`   |      `<leader>cC`       |

You can see more keybindings in `lua/core/mapping.lua` and `lua/keymap/init.lua`.

Note:
1. Put your cursor begin of the begin quote or bracket then press `<A-l>` you will jump to the end of the end quote or bracket.
2. Put your cursor end of the end quote or bracket then press `<A-h>` you will jump to the begin of the begin quote or bracket.