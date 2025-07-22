function Set-VSCode-Configuration {
  $VSCodeSettingsPath = Join-Path -Path $env:appdata -ChildPath "Code" | Join-Path -ChildPath "User";
  $DotfilesVSCodeSettingsFolder = Join-Path -Path $DotfilesWorkFolder -ChildPath "VSCode";

  if (-not (Test-Path -Path $VSCodeSettingsPath)) {
    Write-Host "Configuring Visual Studio Code:" -ForegroundColor "Green";
    New-Item $VSCodeSettingsPath -ItemType directory;
  }

  Get-ChildItem -Path "${DotfilesVSCodeSettingsFolder}\*" -Include "*.json" -Recurse | Copy-Item -Destination $VSCodeSettingsPath;
}

choco install -y "vscode" --params "/NoDesktopIcon /NoQuicklaunchIcon /NoContextMenuFiles /NoContextMenuFolders";
Set-VSCode-Configuration;
refreshenv;
if (where.exe code) {
  Write-Host "Installing Visual Studio Code extensions:" -ForegroundColor "Yellow"

  # ================================
  # PowerShell Script to Install VS Code Extensions by Groups
  # ================================

  $extensions = @(
    # === Core Language Support ===
    "ms-python.python",
    "ms-python.debugpy",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter",
    "ms-toolsai.jupyter-keymap",
    "ms-toolsai.jupyter-renderers",
    "ms-toolsai.vscode-jupyter-cell-tags",
    "ms-toolsai.vscode-jupyter-slideshow",
    "ms-vscode.powershell",
    "vscjava.vscode-java-pack",
    "bmewburn.vscode-intelephense-client",    # PHP
    "fabiolanciotti.codeigniter-reference-explorer",
    "small.php-ci",                           # PHP intellisense for CodeIgniter
    "ms-vscode.cpptools",
    "ms-vscode.cpptools-extension-pack",
    "ms-vscode.cpptools-themes",
    "ms-vscode.cmake-tools",
    "twxs.cmake",
    "ms-vscode.makefile-tools",               # new addition
    "redhat.java"

    # === Remote & Container Development ===
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode-remote.vscode-remote-extensionpack",
    "ms-vscode.remote-explorer",
    "ms-vscode.remote-server",

    # === DevOps / Terraform / Cloud ===
    "ms-azuretools.vscode-docker",
    "ms-azuretools.vscode-containers",
    "hashicorp.terraform",
    "redhat.ansible",
    "redhat.vscode-yaml",
    "redhat.vscode-xml",
    "redhat.vscode-json",

    # === Git, GitHub and Collaboration ===
    "eamodio.gitlens",
    "github.codespaces",
    "github.copilot",
    "github.copilot-chat",
    "github.vscode-github-actions",
    "github.remotehub",
    "github.vscode-pull-request-github",     # new addition
    "ms-vscode.azure-repos",
    "vscode.vscode-speech",

    # === UI, Themes, Icons ===
    "PKief.material-icon-theme",
    "zhuangtongfa.material-theme",
    "oderwat.indent-rainbow",
    "usernamehw.errorlens",

    # === HTML / CSS / Web ===
    "ecmel.vscode-html-css",
    "formulahendry.auto-rename-tag",
    "pranaygp.vscode-css-peek",

    # === Markdown / Docs ===
    "bierner.github-markdown-preview",
    "davidanson.vscode-markdownlint",
    "yzhang.markdown-all-in-one",

    # === Productivity / Formatting ===
    "esbenp.prettier-vscode",
    "gruntfuggly.todo-tree",
    "ue.alphabetical-sorter",
    "aaron-bond.better-comments",
    "EditorConfig.EditorConfig",              # new addition
    "streetsidesoftware.code-spell-checker",

    # === Tools / Runners ===
    "formulahendry.code-runner",
    "ms-vscode.live-server",
    "rangav.vscode-thunder-client",

    # === AI Coding Assistants ===
    "github.copilot",                  # Keeping only GitHub Copilot
    "saoudrizwan.claude-dev",          # Optional, if you use Claude for code
    # Uncomment if you prefer Codeium over Copilot
    # "codeium.codeium",

    # === Collaboration (Optional) ===
    "ms-vsliveshare.vsliveshare"
  )

  # Install all extensions
  foreach ($ext in $extensions) {
    Write-Host "Installing Extension: $ext"
    code --install-extension $ext
  }

  Write-Host "Visual Studio Code extensions have been successfully installed.`n" -ForegroundColor "Green"
}
