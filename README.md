<h1 align="center">
    nvimdots
    <br>
    <a href="https://github.com/neovim/neovim/releases/tag/stable">
    <img
        alt="Neovim Version Capability"
        src="https://img.shields.io/badge/Supports%20Nvim-v0.10-A6D895?style=for-the-badge&colorA=363A4F&logo=neovim&logoColor=D9E0EE">
    </a>
    <a href="https://github.com/ayamir/nvimdots/releases">
    <img
        alt="Release"
        src="https://img.shields.io/github/v/release/ayamir/nvimdots.svg?style=for-the-badge&logo=github&color=F2CDCD&logoColor=D9E0EE&labelColor=363A4F">
    </a>
</h1>

<p align="center">
    <a href="https://github.com/ayamir/nvimdots/stargazers">
    <img
        alt="Stars"
        src="https://img.shields.io/github/stars/ayamir/nvimdots?colorA=363A4F&colorB=B7BDF8&logo=adafruit&logoColor=D9E0EE&style=for-the-badge">
    </a>
    <a href="https://github.com/ayamir/nvimdots/issues">
    <img
        alt="Issues"
        src="https://img.shields.io/github/issues-raw/ayamir/nvimdots?colorA=363A4f&colorB=F5A97F&logo=github&logoColor=D9E0EE&style=for-the-badge">
    </a>
    <a href="https://github.com/ayamir/nvimdots/contributors">
    <img
        alt="Contributors"
        src="https://img.shields.io/github/contributors/ayamir/nvimdots?colorA=363A4F&colorB=B5E8E0&logo=git&logoColor=D9E0EE&style=for-the-badge">
    </a>
    <img
        alt="Code Size"
        src="https://img.shields.io/github/languages/code-size/ayamir/nvimdots?colorA=363A4F&colorB=DDB6F2&logo=gitlfs&logoColor=D9E0EE&style=for-the-badge">
</p>

## 🪷 Introduction

This repo hosts our [Neovim](https://neovim.io/) configuration for Linux [(with NixOS support)](#nixos-support), macOS, and Windows. `init.lua` is the config entry point.

Branch info:

<div align="center">

| Branch | Supported Neovim version |
| :----: | :----------------------: |
|  main  |     nvim 0.10 stable     |
|  0.11  |    nvim 0.11 nightly     |
|  0.9   |         nvim 0.9         |
|  0.8   |         nvim 0.8         |

</div>

> [!IMPORTANT]
> The `0.11` branch is intended for nightly Neovim builds and is **not** stable. It typically harbors subtle issues scattered throughout. Therefore, refrain from submitting issues if you happen to encounter them. They will be closed directly unless a viable solution is proposed or included.

We currently manage plugins using [lazy.nvim](https://github.com/folke/lazy.nvim).

Chinese introduction is [here](https://zhuanlan.zhihu.com/p/382092667).

### 🎐 Features

- **Fast.** Less than **50ms** to start (Depends on SSD and CPU, tested on Zephyrus G14 2022 version).
- **Simple.** Runs out of the box.
- **Modern.** Pure `lua` config.
- **Modular.** Easy to customize.
- **Powerful.** Full functionality to code.

## 🏗 How to Install

Simply run the following interactive bootstrap command, and you should be all set 👍

- **Windows** _(Note: This script REQUIRES `pwsh` > `v7.1`)_

```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.ps1'))
```

- **\*nix**

```sh
if command -v curl >/dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"
else
    bash -c "$(wget -O- https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"
fi
```

It's strongly recommended to read [Wiki: Prerequisites](https://github.com/ayamir/nvimdots/wiki/Prerequisites) before starting, especially for \*nix users.

## ⚙️ Configuration & Usage

<h3 align="center">
    🗺️ Keybindings
</h3>
<p align="center">See <a href="https://github.com/ayamir/nvimdots/wiki/Keybindings" rel="nofollow">Wiki: Keybindings</a> for details</p>
<br>

<h3 align="center">
    🔌 Plugins & Deps
</h3>
<p align="center">See <a href="https://github.com/ayamir/nvimdots/wiki/Plugins" rel="nofollow">Wiki: Plugins</a> for details <br><em>(You can also find a deps diagram there!)</em></p>
<br>

<h3 align="center">
    🔧 Usage & Customization
</h3>
<p align="center">See <a href="https://github.com/ayamir/nvimdots/wiki/Usage" rel="nofollow">Wiki: Usage</a> for details</p>
<br>

<h3 align="center" id="nixos-support" name="nixos-support">
    ❄️  NixOS Support
</h3>
<p align="center">See <a href="https://github.com/ayamir/nvimdots/wiki/NixOS-Support" rel="nofollow">Wiki: NixOS Support</a> for details</p>
<br>

<h3 align="center">
    🤔 FAQ
</h3>
<p align="center">See <a href="https://github.com/ayamir/nvimdots/wiki/Issues" rel="nofollow">Wiki: FAQ</a> for details</p>

## ✨ Features

<h3 align="center">
    ⏱️  Startup Time
</h3>

<p align="center">
  <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/startuptime.png"
  width = "80%"
  alt = "StartupTime"
  />
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/vimstartup.png"
  width = "60%"
  alt = "Vim-StartupTime"
  />
</p>

> Tested with [rhysd/vim-startuptime](https://github.com/rhysd/vim-startuptime)

<h3 align="center">
    📸 Screenshots
</h3>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/dashboard.png" alt="Dashboard">
    <em>Dashboard</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/telescope.png" alt="Telescope">
    <em>Telescope</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/coding.png" alt="Coding">
    <em>Coding</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/code_action.png" alt="Code Action">
    <em>Code Action</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/dap.png" alt="Debugging">
    <em>Debugging</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/lazygit.png" alt="Lazygit">
    <em>Lazygit with built-in Terminal</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/blog-imgs/main/command_ref.png" alt="Command quickref">
    <em>Command quickref</em>
</p>

## 👐 Contributing

- If you find anything that needs improving, do not hesitate to point it out or create a PR.
- If you come across an issue, you can first use `:checkhealth` command provided by nvim to trouble-shoot yourself.
  - If you still have such problems, feel free to open a new issue!

## ❤️ Thanks to

- [ayamir](https://github.com/ayamir)
- [Jint-lzxy](https://github.com/Jint-lzxy)
- [CharlesChiuGit](https://github.com/CharlesChiuGit)
- [aarnphm](https://github.com/aarnphm)
- [misumisumi](https://github.com/misumisumi)

## 🎉 Acknowledgement

- [glepnir/nvim](https://github.com/glepnir/nvim)

## 📜 License

This Neovim configuration is released under the BSD 3-Clause license, which grants the following permissions:

- Commercial use
- Distribution
- Modification
- Private use

For more convoluted language, see the [LICENSE](https://github.com/ayamir/nvimdots/blob/main/LICENSE).
