# Table of Contents

1. [Prerequisites](#prerequisites)
2. [Introduction](#introduction)
3. [Structure](#structure)
4. [Plugins](#plugins)
5. [Usage](#usage)

<a id="prerequisites"></a>

# Prerequisites

**Nvim version > 0.5**

<a id="introduction"></a>

# Introduction

![nvim-light](shots/light-nvim.png)

![nvim-light-coding](shots/light-nvim-coding.png)

![nvim-nord](shots/nord-nvim.png)

![nvim-nord-coding](shots/nord-nvim-coding.png)

This is my neovim's configuration.

I use [Vim-Plug](https://github.com/junegunn/vim-plug) to manage plugins.

I use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to realize code complete.

<a id="structure"></a>

# Structure

`init.vim` is the kernel config file.

The first part is the common settings of neovim.

The second part is Vim-Plug's settings which consists of all of my plugins.

The third part is common simple keybinding settings about some plugins.

`plugin` directory includes some plugins' specific settings.

<a id="plugins"></a>

# Plugins

## UI

| Name                                                                 | Effect                              |
| :----:                                                               | :----:                              |
| [onehalf](https://github.com/sonph/onehalf)                          | My light theme                      |
| [nord-vim](https://github.com/arcticicestudio/nord-vim)              | My dark theme                       |
| [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) | For nvim-tree's icons               |
| [galaxyline.nvim](https://github.com/glepnir/galaxyline.nvim)        | Minimal, fast but customizable line |
| [dashboard-nvim](https://github.com/glepnir/dashboard-nvim)          | Dashboard for Neovim                |
| [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)         | Replacement of Nerdtree             |

## File jump

| Name                                                               | Effect                      |
| :----:                                                             | :----:                      |
| [popup.nvim](https://github.com/nvim-lua/popup.nvim)               | Required by telescope.nvim  |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)           | Required by telescope.nvim  |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Find, Filter, Preview, Pick |

## Common coding tools

| Name                                                                  | Effect                                  |
| :----:                                                                | :----:                                  |
| [tabular](https://github.com/godlygeek/tabular)                       | Line up with regex                      |
| [indentLine](https://github.com/Yggdroot/indentLine)                  | Note each indent level                  |
| [vim-commentary](https://github.com/tpope/vim-commentary)             | Comment code quickly                    |
| [tagbar](https://github.com/majutsushi/tagbar)                        | Display code structure                  |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Super powerful code highlighter         |
| [neoformat](https://github.com/sbdchd/neoformat)                      | Super powerful code formater            |
| [vim-gitgutter](https://github.com/airblade/vim-gitgutter)            | Show git status in nvim                 |
| [any-jump.vim](https://github.com/pechorin/any-jump.vim)              | Jump to any definition and references   |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)            | Powerful autopairs for Neovim           |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)          | Faster vim-closetag                     |
| [accelerated-jk](https://github.com/rhysd/accelerated-jk)             | Accelerated J/K                         |
| [vim-sneak](https://github.com/justinmk/vim-sneak)                    | Minimal easymotion, powerful vim motion |
| [vim-slash](https://github.com/junegunn/vim-slash)                    | Elegant search in vim                   |
| [split-term](https://github.com/vimlab/split-term.vim)                | Utilites around neovim's `:terminal`    |
| [vim-quickrun](https://github.com/thinca/vim-quickrun)                | Just run code quickly                   |

## Specific coding tools
| Name                                                                     | Effect                                |
| :----:                                                                   | :----:                                |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)               | Neovim native LSP configuration       |
| [nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall)          | Manage every LSP engine               |
| [lspkind-nvim](https://github.com/onsails/lspkind-nvim)                  | Vscode-like pictograms for neovim lsp |
| [nvim-compe](https://github.com/hrsh7th/nvim-compe)                      | Auto completion plugin for nvim       |
| [compe-tabnine](https://github.com/tzachar/compe-tabnine)                | Tabnine port for nvim-compe           |
| [snippets.nvim](https://github.com/norcalli/snippets.nvim)               | Snippets port for nvim-compe          |
| [vim-go](https://github.com/fatih/vim-go)                                | Most powerful plugin for go           |
| [rust.vim](https://github.com/rust-lang/rust.vim)                        | Plugin for rust                       |
| [vim-css-color](https://github.com/ap/vim-css-color)                     | Display detected color                |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Markdown-preview out of box           |


<a id="usage"></a>

# Usage

To make sure Vim-Plug can be downloaded normally, you should add this line to your `/etc/hosts`:

```shell
151.101.64.133 	raw.githubusercontent.com
```

The leader key is space.

`<leader><leader>i` to use Vim-Plug install all of plugins.

`<leader><leader>u` to update all of plugins.

`<leader><leader>c` to clean redundant plugins.

You can see all of keybindings in my `init.vim`.
