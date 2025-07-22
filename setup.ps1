#Requires -Version 5
$GitHubRepositoryAuthor = "Brahmatruti";
$GitHubRepositoryName = "windowsdotfiles";
$DotfilesFolder = Join-Path -Path $HOME -ChildPath ".dotfiles";
$DotfilesWorkFolder = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main";# | Join-Path -ChildPath "src";
$DotfilesHelpersFolder = Join-Path -Path $DotfilesWorkFolder -ChildPath "Helpers";
$DotfilesConfigFile = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main" | Join-Path -ChildPath "config.json";


Write-Host "Welcome to Dotfiles for Microsoft Windows 11" -ForegroundColor "Yellow";
Write-Host "Please don't use your device while the script is running." -ForegroundColor "Yellow";

Write-Host "GitHubRepositoryName:" $GitHubRepositoryName;
Write-Host "DotfilesFolder:" $DotfilesFolder;
Write-Host "DotfilesWorkFolder: "$DotfilesWorkFolder;
Write-Host "DotfilesHelpersFolder:" $DotfilesHelpersFolder;
Write-Host "DotfilesConfigFile:" $DotfilesConfigFile;



# Load helpers
Write-Host "Loading helpers:" -ForegroundColor "Green";
$DotfilesHelpers = Get-ChildItem -Path "${DotfilesHelpersFolder}\*" -Include *.ps1 -Recurse;
foreach ($DotfilesHelper in $DotfilesHelpers) {
    . $DotfilesHelper;
};

if (($PSVersionTable.PSVersion.Major) -lt 5) {
    Write-Output "PowerShell 5 or later is required to run."
    break
}

$isadmin = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")
if (-not ($isadmin)) { throw "Must have Admininstrative Priveledges..." }

Write-Host "Configuring System..." -ForegroundColor "Yellow"

# Custom functions
function Hide-File {
    param([Parameter(Mandatory)][string]$Path)

    if (!(((Get-Item -Path $Path -Force).Attributes.ToString() -Split ", ") -Contains "Hidden")) {
        (Get-Item -Path $Path -Force).Attributes += "Hidden"
    }
}

function New-Directory {
    param ([Parameter(Mandatory)][string]$Path, [switch]$Hide)

    PROCESS {
        If (!(test-path $Path)) {
            New-Item -Path $Path -ItemType "directory" | Out-Null
        }

        if ($Hide) { Hide-File($Path) }
    }
}

function Set-Softlink {
    param ([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][string]$Target, [switch]$Hide)

    PROCESS {
        if (Test-Path -Path $Path) {
            if (!(Get-Item $Path -Force).LinkType -eq "SymbolicLink") {
                Write-Host "Old file renamed to $((Get-Item -Path $Path).Name).old..." -ForegroundColor Blue
                Rename-Item -Path $Path -NewName "$((Get-Item -Path $Path).Name).old"

                Write-Host "Linking: $Target->$Path..." -ForegroundColor Blue
                New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
            }
        }
        else {
            Write-Host "Linking: $Target->$Path..." -ForegroundColor Blue
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        }

        if ($Hide) { Hide-File($Path) }
    }
}

function Find-Installed( $programName ) {
    $x86_check = ((Get-ChildItem "HKLM:Software\Microsoft\Windows\CurrentVersion\Uninstall") |
        Where-Object { $_."Name" -like "*$programName*" } ).Length -gt 0;

    if (Test-Path 'HKLM:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') {
        $x64_check = ((Get-ChildItem "HKLM:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
            Where-Object { $_."Name" -like "*$programName*" } ).Length -gt 0;
    }
    return $x86_check -or $x64_check;
}


Set-Configuration-File -DotfilesConfigFile $DotfilesConfigFile -ComputerName $ComputerName -GitUserName $GitUserName -GitUserEmail $GitUserEmail -WorkspaceDisk $WorkspaceDisk;

# Load user configuration from persistence
$Config = Get-Configuration-File -DotfilesConfigFile $DotfilesConfigFile;


# Trust PSrepository

if (-not (Get-PackageProvider-Installation-Status -PackageProviderName "NuGet")) {
    Write-Host "Installing NuGet as package provider:" -ForegroundColor "Green";
    Install-PackageProvider -Name "NuGet" -Force;
}

if (-not (Get-PSRepository-Trusted-Status -PSRepositoryName "PSGallery")) {
    Write-Host "Setting up PSGallery as PowerShell trusted repository:" -ForegroundColor "Green";
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted;
}

if (-not (Get-Module-Installation-Status -ModuleName "PackageManagement" -ModuleMinimumVersion "1.4.6")) {
    Write-Host "Updating PackageManagement module:" -ForegroundColor "Green";
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
    Install-Module -Name "PackageManagement" -Force -MinimumVersion "1.4.6" -Scope "CurrentUser" -AllowClobber -Repository "PSGallery";
}


# Create directories
New-Directory -Path "$HOME\repo"
New-Directory -Path "$HOME\.config" -Hide

# Windows config
Invoke-Expression -Command "$PSScriptRoot\windows\windows.ps1"

# Chocolatey
Invoke-Expression -Command "$PSScriptRoot\Chocolatey\Chocolatey.ps1"

# Visual Studio Code VSCode
Invoke-Expression -Command "$PSScriptRoot\VSCode\VSCode.ps1"

# Git
Invoke-Expression -Command "$PSScriptRoot\git\gitsetup.ps1"

# Git2
# Invoke-Expression -Command "$PSScriptRoot\git2\Git.ps1"

# PowerToys
Invoke-Expression -Command "$PSScriptRoot\powertoys\powertoys.ps1"

# WSL
Invoke-Expression -Command "$PSScriptRoot\wsl2\WSL.ps1"

# Windows terminal
Invoke-Expression -Command "$PSScriptRoot\WindowsTerminal\WindowsTerminal.ps1"

# GPG
Invoke-Expression -Command "$PSScriptRoot\gpg\setup.ps1"

# WorkspaceFolder
Invoke-Expression -Command "$PSScriptRoot\WorkspaceFolder\WorkspaceFolder.ps1"

# Fonts
Invoke-Expression -Command "$PSScriptRoot\Fonts\Fonts.ps1"

# Vim
Invoke-Expression -Command "$PSScriptRoot\Vim\vim.ps1"


# Notepad++
Invoke-Expression -Command "$PSScriptRoot\Notepad++\Notepad++.ps1"

# Dotnet
Invoke-Expression -Command "$PSScriptRoot\Dotnet\Dotnet.ps1"

# Docker
Invoke-Expression -Command "$PSScriptRoot\Docker\Docker.ps1"

# AI Tools
Invoke-Expression -Command "$PSScriptRoot\ai-tools\ai-tool.ps1"

# Powershell
Invoke-Expression -Command "$PSScriptRoot\powershell\powershell.ps1"

Write-Host "Deleting Desktop shortcuts:" -ForegroundColor "Green";
Remove-Desktop-Shortcuts;

# Write-Host "Cleaning Dotfiles workspace:" -ForegroundColor "Green";
# Remove-Item $DotfilesFolder -Recurse -Force -ErrorAction SilentlyContinue;

Write-Host "The Setup has finished." -ForegroundColor "Yellow";

Write-Host "Restarting the PC in 10 seconds..." -ForegroundColor "Green";
# Start-Sleep -Seconds 10;
Restart-Computer -Confirm;

