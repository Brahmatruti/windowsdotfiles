# Dotfiles for Microsoft Windows 11

Repeatable, reboot resilient Dotfiles script to setup a development environment in Microsoft Windows 11.

PowerShell 'dotfiles' for Windows, including common application installations through `winget`, as well as developer-friendly Windows configuration defaults.

> Now you create and run 🚀 Dotfiles projects for Windows 10/11 using this module for PowerShell: [WindowsDotfiles](https://github.com/Brahmatruti/WindowsDotfiles)



## Directory structure

The repository follows a straight forward folder structure. For clearification each subdirectory and important file is explained in the table under.

|       Folder | Description                                             |
| -----------: | :------------------------------------------------------ |
|    _.vscode_ | Project configuration for Visual Studio Code.           |
|        _git_ | Configuration files related to git.                     |
|        _gpg_ | Key, configuration and setup files for gpg.             |
| _powershell_ | Configuration and setup files related to powershell.    |
|  _powertoys_ | Configuration and setup files related to powertoys.     |
|        _ssh_ | Key and configuration files related to ssh.             |
|   _terminal_ | Configuration files related to Windows terminal.        |
|    _windows_ | Configuration related to Windows.                       |
|        _wsl_ | Configuration files related to Windows-side WSL.        |
|  _setup.ps1_ | Main setup script.                                      |



## Usage
> **Note**
> Windows Package Manager `winget` command-line tool is bundled with Windows 11 and modern versions of Windows 10 by default as the App Installer. [Read more](https://docs.microsoft.com/en-us/windows/package-manager/winget/)

## Initialization (Installation)

Open any Windows PowerShell 5.1 _(or later) host console **(Except Windows Terminal)** with administrator rights and run:

```Powershell
$GitHubRepositoryAuthor = "Brahmatruti"; `
$GitHubRepositoryName = "windowsdotfiles"; `
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; `
Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/${GitHubRepositoryAuthor}/${GitHubRepositoryName}/main/Download.ps1");
```

The `Download.ps1` script will download and copy the files to your `${HOME}\.dotfiles` directory. Then, the `Setup.ps1` script will be launched automatically, which is responsible for configuring the machine.

> **Note**
> You must have your execution policy set to Unrestricted (or at least in Bypass) for this to work _(As a developer, you will need it anyway)_.


The dotfiles contain configuration for many different programs, and settings used in Windows 10/11. The setup script included install most programs, not included by default in Windows 10/11, that has a configuration in this repository. All subfolders has a `setup.ps1` script installing related programs and linking all configuration files. A main script in the root of this repository contain functions used in all following scripts and activate all following scripts handling the installation.



## What does?

This dotfiles script does:

- Install Chocolatey.
- Configure Chocolatey to remember installation arguments for future updates.
- Install Hack Nerd Font.
- Install Git.
- Configure Git.
- Install Vim.
- Install Vim-Plug.
- Install Vim plugins.
- Install Visual Studio Code.
- Configure Visual Studio Code.
- Install Visual Studio Code extensions.
- Install Oh My Posh for PowerShell.
- Configure Oh My Posh theme.
- Install Posh-Git for Oh My Posh.
- Install Terminal-Icons for PowerShell.
- Configure PSWebSearch for PowerShell.
- Configure PSReadLine for PowerShell.
- Configure Windows Terminal.
- Install Notepad++.
- Configure Notepad++.
- Install .NET SDK.
- Enable Windows Subsystem for Linux.
- Install Ubuntu 20.04 LTS in WSL.
  - Install curl.
  - Install Neofetch.
  - Configure Git in Ubuntu.
  - Install Visual Studio Code extensions in Ubuntu.
  - Install Volta in Ubuntu.
    - Install Node.js LTS using Volta in Ubuntu.
    - Install NPM using Volta in Ubuntu.
    - Install Yarn using Volta in Ubuntu.
    - Install TypeScript using Volta in Ubuntu.
    - Install Yarn-Upgrade-All using Volta in Ubuntu.
    - Install NestJS CLI using Volta in Ubuntu.
  - Install Golang in Ubuntu.
  - Install HUGO in Ubuntu.
  - Install Vim in Ubuntu.
  - Install Vim-Plug in Ubuntu.
  - Install Vim plugins in Ubuntu.
  - Install Zsh in Ubuntu.
  - Install Oh My Zsh in Ubuntu.
  - Install Zsh-Autosuggestions for Oh My Zsh in Ubuntu.
  - Configure Oh My Zsh in Ubuntu.
- Install Docker Desktop.
- Configure File Explorer:
  - Show file extensions.
  - Open file explorer to This PC.
  - Set as background option moved to extended Context Menu.
  - Disable recently opened items from JumpList.
- Microsoft Windows optional features:
  - Disable Windows Media Player.
  - Disable Internet Explorer.
  - Disable Microsoft XPS Document Writer.
  - Disable WorkFolders Client.
  - Enable Windows Sandbox.
- Configure Windows 11 power plan.
- Configure Windows 11 regional format:
  - First day of week: Monday.
  - Short date: 2017-04-05.
  - Long date: Wednesday, 5 April, 2017.
  - Short time: 19:40.
  - Long time: 19:40:07.
- Rename PC.

## Windows Terminal Custom Keyboard Shortcuts

| Action                            | Keyboard Shortcut |
| --------------------------------- | ----------------- |
| Open New Tab                      | ctrl+t            |
| Close Current Pane                | ctrl+w            |
| Open New Split Pane in Horizontal | alt+shift+h       |
| Open New Split Pane in Vertical   | alt+shift+v       |

## Alias and functions for PowerShell & Zsh

### Terminal Profile

| Alias | Description              | PowerShell | Zsh |
| ----- | ------------------------ | ---------- | --- |
| edt   | Edit terminal profile    | ✅         | ✅  |
| src   | Refresh terminal profile | ✅         | ✅  |

### Directories

| Alias | Description                      | PowerShell | Zsh |
| ----- | -------------------------------- | ---------- | --- |
| mkcd  | Create folder and navigate to it | ✅         | ✅  |
| trash | Open the recycle bin folder      | ✅         |     |

### System Maintenance

| Alias  | Description             | PowerShell | Zsh |
| ------ | ----------------------- | ---------- | --- |
| updsys | Update apps and system. | ✅         | ✅  |

### Environment Variables

| Alias | Description                                    | PowerShell | Zsh |
| ----- | ---------------------------------------------- | ---------- | --- |
| pathl | List the content of PATH environment variables | ✅         | ✅  |

### Git

| Alias | Description                                                      | PowerShell | Zsh |
| ----- | ---------------------------------------------------------------- | ---------- | --- |
| gcb   | git checkout creating new branch                                 | ✅         | ✅  |
| ga    | git add                                                          | ✅         | ✅  |
| gaa   | git add all                                                      | ✅         | ✅  |
| gsc   | git clone, load submodules and navigate to the repository folder | ✅         | ✅  |
| gst   | git status                                                       | ✅         | ✅  |
| gcmsg | git commit message                                               | ✅         | ✅  |
| ggp   | git push origin current_branch                                   | ✅         | ✅  |
| glg   | git log                                                          | ✅         | ✅  |
| gsrlc | Git soft reset last commit                                       | ✅         | ✅  |
| ghrlc | Git hard reset last commit                                       | ✅         | ✅  |

### Vim

| Alias     | Description               | PowerShell | Zsh |
| --------- | ------------------------- | ---------- | --- |
| editvim   | Edit .vimrc file          | ✅         | ✅  |
| sourcevim | Refresh Vim configuration |            | ✅  |

### Docker

| Alias | Description                        | PowerShell | Zsh |
| ----- | ---------------------------------- | ---------- | --- |
| dpl   | Docker pull                        | ✅         | ✅  |
| dlc   | List the Docker containers working | ✅         | ✅  |
| dlca  | List all the Docker containers     | ✅         | ✅  |
| dli   | List all the Docker images         | ✅         | ✅  |
| dsc   | Stop Docker container              | ✅         | ✅  |
| drc   | Delete Docker container            | ✅         | ✅  |
| dri   | Delete Docker image                | ✅         | ✅  |

### NPM

| Alias | Description                       | PowerShell | Zsh |
| ----- | --------------------------------- | ---------- | --- |
| ngl   | List global NPM packages          |            | ✅  |
| ngo   | List outdated global NPM packages |            | ✅  |
| ngu   | Update global NPM package         |            | ✅  |

### Yarn

| Alias | Description                                   | PowerShell | Zsh |
| ----- | --------------------------------------------- | ---------- | --- |
| yi    | Install Yarn package                          |            | ✅  |
| yid   | Install Yarn package as dev dependency        |            | ✅  |
| yl    | List all Yarn packages locally installed      |            | ✅  |
| ylo   | List outdated Yarn packages locally installed |            | ✅  |
| yu    | Update Yarn package                           |            | ✅  |
| yua   | Upgrade all Yarn packages                     |            | ✅  |
| yr    | Remove Yarn package                           |            | ✅  |

### NestJS

| Alias   | Description                      | PowerShell | Zsh |
| ------- | -------------------------------- | ---------- | --- |
| nestnew | Create a new project with NestJS |            | ✅  |

### Go

| Alias | Description           | PowerShell | Zsh |
| ----- | --------------------- | ---------- | --- |
| gmi   | Initialize Go modules |            | ✅  |

### Web search from the console

| Alias         | Example                    | PowerShell | Zsh |
| ------------- | -------------------------- | ---------- | --- |
| bing          | bing "Windows 11"          | ✅         | ✅  |
| google        | google "Windows 11"        | ✅         | ✅  |
| duckduckgo    | duckduckgo "Windows 11"    | ✅         | ✅  |
| youtube       | youtube "Windows 11"       | ✅         | ✅  |
| github        | github "Windows 11"        | ✅         | ✅  |
| stackoverflow | stackoverflow "Windows 11" | ✅         | ✅  |


## Acknowledgments

- [jimbrig/jimsdots](https://github.com/jimbrig/jimsdots) for the inspiration to this project.
- [ayharris/dotfiles-windows](https://github.com/jayharris/dotfiles-windows) for specific implementation and settings.
- [JMOrbegoso] https://github.com/JMOrbegoso/Dotfiles-for-Windows-11/tree/main
- [exTerEX] https://github.com/exTerEX/windots
