<h1 align="center">
    nvimdots
    <br>
    <a href="https://github.com/neovim/neovim/releases/tag/stable">
    <img
        alt="Neovim Version Capability"
        src="https://img.shields.io/badge/Supports%20Nvim-v0.11-A6D895?style=for-the-badge&colorA=363A4F&logo=neovim&logoColor=D9E0EE">
    </a>
    <a href="https://github.com/ayamir/nvimdots/releases">
    <img
        alt="Release"
        src="https://img.shields.io/github/v/release/ayamir/nvimdots.svg?style=for-the-badge&logo=github&color=F2CDCD&logoColor=D9E0EE&labelColor=363A4F">
    </a>
    <a href="https://discord.gg/rE46YdFAUc">
      <img
        alt="Discord"
        src="https://img.shields.io/badge/Discord-nvimdots-B4BEFE?style=for-the-badge&colorA=363A4F&logo=discord&logoColor=D9E0EE">
    </a>
    <a href="https://deepwiki.com/ayamir/nvimdots">
      <img
        alt="Ask DeepWiki"
        src="https://img.shields.io/badge/Ask-DeepWiki-D9E0EE?style=for-the-badge&colorA=363A4F&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAzMiAzOCI+PHBhdGggc3R5bGU9ImZpbGw6I2Q5ZTBlZTtzdHJva2U6I2Q5ZTBlZSIgZD0iTTIxLjg4OSAxNi45OThhMi4zMyAyLjMzIDAgMCAxIDIuMzE0IDBsMS44NDggMS4wNjdhMSAxIDAgMCAwIC4yMjkuMDg3cS4wOTcuMDIyLjE5My4wMjZoLjAxcS4wMSAwIC4wMjEtLjAwM2EuOC44IDAgMCAwIC4zODgtLjEwNWwuMDE4LS4wMDggMy42OTQtMi4xMzRhLjg1Ljg1IDAgMCAwIC40MjctLjc0di00LjI2N2EuODUuODUgMCAwIDAtLjQyNy0uNzRMMjYuOTEgOC4wNDdhLjg2Ljg2IDAgMCAwLS44NTYgMGwtMy42OTQgMi4xMzRzLS4wMS4wMDgtLjAxNS4wMWEuOC44IDAgMCAwLS4xNTcuMTIxbC0uMDIxLjAyM2ExIDEgMCAwIDAtLjExLjE0NHEtLjAwOC4wMS0uMDE1LjAyNmEuOS45IDAgMCAwLS4xMTEuNDIydjIuMTM0YTIuMzE0IDIuMzE0IDAgMCAxLTMuNDcxIDIuMDAybC0xLjg0OC0xLjA2N2ExIDEgMCAwIDAtLjIyOS0uMDg3IDEgMSAwIDAgMC0uMTkzLS4wMjZoLS4wMjhhLjguOCAwIDAgMC0uMzkxLjEwM2wtLjAxOC4wMDgtMy42OTQgMi4xMzRhLjg1Ljg1IDAgMCAwLS40MjcuNzR2NC4yNjdhLjg1Ljg1IDAgMCAwIC40MjcuNzRsMy42OTQgMi4xMzQuMDE4LjAwOGExIDEgMCAwIDAgLjE4My4wNzVsLjAzMS4wMDhhMSAxIDAgMCAwIC4xNzcuMDIzbC4wMjEuMDAzaC4wMWEuOC44IDAgMCAwIC4xOTMtLjAyNnEuMDE5LS4wMDYuMDQxLS4wMWExIDEgMCAwIDAgLjE4OC0uMDc3bDEuODQ4LTEuMDY3YTIuMzIgMi4zMiAwIDAgMSAyLjMxMyAwIDIuMzIgMi4zMiAwIDAgMSAxLjE1NyAyLjAwM3YyLjEzNHEuMDAxLjEwNC4wMjYuMi4wMDMuMDIuMDEuMDQxYTEgMSAwIDAgMCAuMDc0LjE4bC4wMTYuMDI2cS4wNDYuMDc3LjExMS4xNDRsLjAyMS4wMjNxLjA3LjA2OC4xNTcuMTIxbC4wMTUuMDEgMy42OTQgMi4xMzRhLjg1Ljg1IDAgMCAwIC44NTQgMGwzLjY5NC0yLjEzNGEuODUuODUgMCAwIDAgLjQyNy0uNzR2LTQuMjY3YS44NS44NSAwIDAgMC0uNDI3LS43NGwtMy42OTQtMi4xMzQtLjAxOC0uMDA4YTEgMSAwIDAgMC0uMTgyLS4wNzVsLS4wMjgtLjAwNWEuNy43IDAgMCAwLS4xOC0uMDIzaC0uMDI4YS44LjggMCAwIDAtLjE5My4wMjZsLS4wMzguMDFhMSAxIDAgMCAwLS4xODguMDc3bC0xLjg0OCAxLjA2N2EyLjMyIDIuMzIgMCAwIDEtMi4zMTMgMGMtLjcxMi0uNDExLTEuMTU3LTEuMTgtMS4xNTctMi4wMDNzLjQ0Mi0xLjU5MSAxLjE1Ny0yLjAwM2wtLjAwMy0uMDFaTTEuNzYzIDE1LjkzMmwzLjY5NCAyLjEzNGEuODUuODUgMCAwIDAgLjg1NCAwbDMuNjk0LTIuMTM0cy4wMS0uMDA4LjAxNS0uMDFhLjguOCAwIDAgMCAuMTU3LS4xMjFsLjAyMS0uMDIzcS4wNi0uMDY3LjExMS0uMTQ0LjAwOC0uMDEuMDE1LS4wMjZhLjkuOSAwIDAgMCAuMTExLS40MjF2LTIuMTM0YTIuMzE0IDIuMzE0IDAgMCAxIDMuNDcxLTIuMDAybDEuODQ4IDEuMDY3YTEgMSAwIDAgMCAuMjI5LjA4N3EuMDk0LjAyMi4xOTMuMDI2aC4wMWwuMDIxLS4wMDNhLjguOCAwIDAgMCAuMzkxLS4xMDZsLjAxOC0uMDA4TDIwLjMxIDkuOThhLjg1Ljg1IDAgMCAwIC40MjctLjc0VjQuOTczYS44NS44NSAwIDAgMC0uNDI3LS43NGwtMy42OTQtMi4xMzRhLjg2Ljg2IDAgMCAwLS44NTYgMGwtMy42OTQgMi4xMzRzLS4wMS4wMDgtLjAxNS4wMWEuOC44IDAgMCAwLS4xNTcuMTIxbC0uMDIxLjAyM2ExIDEgMCAwIDAtLjExMS4xNDRxLS4wMDguMDEtLjAxNS4wMjZhLjkuOSAwIDAgMC0uMTExLjQyMnYyLjEzNGMwIC44MjMtLjQ0MiAxLjU5MS0xLjE1NyAyLjAwM2EyLjMzIDIuMzMgMCAwIDEtMi4zMTQgMEw2LjMxNyA4LjA0OWExIDEgMCAwIDAtLjIyOS0uMDg3IDEgMSAwIDAgMC0uMTkzLS4wMjZoLS4wMjhhLjguOCAwIDAgMC0uMzkxLjEwM2wtLjAxOC4wMDgtMy42OTQgMi4xMzRhLjg1Ljg1IDAgMCAwLS40MjcuNzR2NC4yNjdhLjg1Ljg1IDAgMCAwIC40MjcuNzR2LjAwNVptMTguNTQyIDEyLjA4Mi0zLjY5NC0yLjEzNC0uMDE4LS4wMDhhMSAxIDAgMCAwLS4xODMtLjA3NGwtLjAzMS0uMDA4YTEgMSAwIDAgMC0uMTgtLjAyM2gtLjAyOGEuOC44IDAgMCAwLS4xOTMuMDI2bC0uMDM5LjAxYTEgMSAwIDAgMC0uMTg4LjA3N2wtMS44NDggMS4wNjdhMi4zMiAyLjMyIDAgMCAxLTIuMzExIDAgMi4zMiAyLjMyIDAgMCAxLTEuMTU3LTIuMDAzVjIyLjgxYS44LjggMCAwIDAtLjAzNi0uMjQyIDEgMSAwIDAgMC0uMDc1LS4xOHEtLjAwOC0uMDEtLjAxNS0uMDI2YS44LjggMCAwIDAtLjExMS0uMTQ0bC0uMDItLjAyM2ExIDEgMCAwIDAtLjE1Ny0uMTIxbC0uMDE1LS4wMS0zLjY5NC0yLjEzNGEuODYuODYgMCAwIDAtLjg1NiAwbC0zLjY5NCAyLjEzNGEuODUuODUgMCAwIDAtLjQyNy43NHY0LjI2N2EuODUuODUgMCAwIDAgLjQyNy43NGwzLjY5NCAyLjEzNC4wMTguMDA4YTEgMSAwIDAgMCAuMTguMDc0bC4wMzEuMDA4YTEgMSAwIDAgMCAuMTc3LjAyM2wuMDIxLjAwMmguMDFxLjA5Ny0uMDAxLjE5LS4wMjYuMDItLjAwNi4wNDEtLjAxYTEgMSAwIDAgMCAuMTg4LS4wNzdMOC4xNiAyOC44OGEyLjMzIDIuMzMgMCAwIDEgMi4zMTQgMCAyLjMyIDIuMzIgMCAwIDEgMS4xNTcgMi4wMDN2Mi4xMzRxLjAwMS4xMDQuMDI2LjIwMS4wMDMuMDIuMDEuMDQxYTEgMSAwIDAgMCAuMDc1LjE4cS4wMDguMDEuMDE1LjAyNi4wNDYuMDc3LjExMS4xNDRsLjAyLjAyM3EuMDcuMDY4LjE1Ny4xMjEuMDA3LjAwNi4wMTYuMDFsMy42OTQgMi4xMzRhLjg1Ljg1IDAgMCAwIC44NTQgMGwzLjY5NC0yLjEzNGEuODUuODUgMCAwIDAgLjQyNy0uNzR2LTQuMjY3YS44NS44NSAwIDAgMC0uNDI3LS43NHoiLz48L3N2Zz4=&logoColor=D9E0EE">
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
|  main  |     nvim 0.11 stable     |
|  0.12  |    nvim 0.12 nightly     |
|  0.10  |        nvim 0.10         |
|  0.9   |         nvim 0.9         |

</div>

> [!IMPORTANT]
> The `0.12` branch is intended for nightly Neovim builds and is **not** stable. It typically harbors subtle issues scattered throughout. Therefore, refrain from submitting issues if you happen to encounter them. They will be closed directly unless a viable solution is proposed or included.

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
  <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/startuptime.png"
  width = "80%"
  alt = "StartupTime"
  />
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/vimstartup.png"
  width = "60%"
  alt = "Vim-StartupTime"
  />
</p>

> Tested with [rhysd/vim-startuptime](https://github.com/rhysd/vim-startuptime)

<h3 align="center">
    📸 Screenshots
</h3>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/dashboard.png" alt="Dashboard">
    <em>Dashboard</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/telescope.png" alt="Telescope">
    <em>Telescope</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/coding.png" alt="Coding">
    <em>Coding with LLM</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/code_action.png" alt="Code Action">
    <em>Code Action</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/dap.png" alt="Debugging">
    <em>Debugging</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/lazygit.png" alt="Lazygit">
    <em>Lazygit with built-in Terminal</em>
</p>
<br>

<p align="center">
    <img src="https://raw.githubusercontent.com/ayamir/nvimdots-imgs/main/command_ref.png" alt="Command quickref">
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
