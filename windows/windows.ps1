#!/usr/bin/env pwsh

function Set-WindowsExplorer-ShowFileExtensions {
  Write-Host "Configuring Windows File Explorer to show file extensions:" -ForegroundColor "Green";

  $RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
  Set-ItemProperty -Path $RegPath -Name "HideFileExt" -Value 0;
}

function Set-WindowsFileExplorer-StartFolder {
  Write-Host "Configuring start folder of Windows File Explorer:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";

  if (-not (Test-PathRegistryKey -Path $RegPath -Name "LaunchTo")) {
    New-ItemProperty -Path $RegPath -Name "LaunchTo" -PropertyType DWord;
  }

  Set-ItemProperty -Path $RegPath -Name "LaunchTo" -Value 1; # [This PC: 1], [Quick access: 2], [Downloads: 3]
}

function Set-Multitasking-Configuration {
  Write-Host "Configuring Multitasking settings (Snap layouts):" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";

  # When I snap a window, show what I can snap next to it.
  Set-ItemProperty -Path $RegPath -Name "SnapAssist" -Value 0;
  # Show snap layouts that the app is part of when I hover over the taskbar buttons.
  Set-ItemProperty -Path $RegPath -Name "EnableTaskGroups" -Value 0;
  # When I resize a snapped window, simultaneously resize any adjacent snapped window.
  Set-ItemProperty -Path $RegPath -Name "JointResize" -Value 0;

  # Show snap layout when I hover over a window's maximize button.
  Set-ItemProperty -Path $RegPath -Name "EnableSnapAssistFlyout" -Value 1;
  # When I drag a window, let me snap it without dragging all the way to the screen edge.
  Set-ItemProperty -Path $RegPath -Name "DITest" -Value 1;
  # When I snap a window, automatically size it to fill available space.
  Set-ItemProperty -Path $RegPath -Name "SnapFill" -Value 1;

  Write-Host "Multitasking successfully updated." -ForegroundColor "Green";
}

function Set-Classic-ContextMenu-Configuration {
  Write-Host "Activating classic Context Menu:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}";
  $RegKey = "(Default)";

  if (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath;
  }

  $RegPath = $RegPath | Join-Path -ChildPath "InprocServer32";

  if (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath;
  }

  if (-not (Test-PathRegistryKey -Path $RegPath -Name $RegKey)) {
    New-ItemProperty -Path $RegPath -Name $RegKey -PropertyType String;
  }
  Set-ItemProperty -Path $RegPath -Name $RegKey -Value "";

  Write-Host "Classic Context Menu successfully activated." -ForegroundColor "Green";
}

function Set-SetAsBackground-To-Extended-ContextMenu {
  Write-Host "Configuring Context Menu to show the option 'Set as Background' just in Extended Context Menu:" -ForegroundColor "Green";

  $Extensions = ".bmp", ".dib", ".gif", ".jfif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff", ".wdp";

  foreach ($Extension in $Extensions) {
    $RegPath = "HKCR:\SystemFileAssociations\${Extension}\Shell\setdesktopwallpaper";

    if (Test-Path $RegPath) {
      if (-not (Test-PathRegistryKey -Path $RegPath -Name "Extended")) {
        New-ItemProperty -Path $RegPath -Name "Extended" -PropertyType String;
      }
    }
  }
}

function Disable-RecentlyOpenedItems-From-JumpList {
  Write-Host "Configuring Jump List to do not show the list of recently opened items:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
  if (-not (Test-PathRegistryKey -Path $RegPath -Name "Start_TrackDocs")) {
    New-ItemProperty -Path $RegPath -Name "Start_TrackDocs" -PropertyType DWord;
  }
  Set-ItemProperty -Path $RegPath -Name "Start_TrackDocs" -Value 0;
}

function Set-Power-Configuration {
  Write-Host "Configuring power plan:" -ForegroundColor "Green";
  # AC: Alternating Current (Wall socket).
  # DC: Direct Current (Battery).

  # Set turn off disk timeout (in minutes / 0: never)
  powercfg -change "disk-timeout-ac" 0;
  powercfg -change "disk-timeout-dc" 0;

  # Set hibernate timeout (in minutes / 0: never)
  powercfg -change "hibernate-timeout-ac" 0;
  powercfg -change "hibernate-timeout-dc" 0;

  # Set sleep timeout (in minutes / 0: never)
  powercfg -change "standby-timeout-ac" 0;
  powercfg -change "standby-timeout-dc" 0;

  # Set turn off screen timeout (in minutes / 0: never)
  powercfg -change "monitor-timeout-ac" 10;
  powercfg -change "monitor-timeout-dc" 10;

  # Set turn off screen timeout on lock screen (in seconds / 0: never)
  powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 30;
  powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 30;
  powercfg /SETACTIVE SCHEME_CURRENT;

  Write-Host "Power plan successfully updated." -ForegroundColor "Green";
}

function Set-Custom-Regional-Format {
  Write-Host "Configuring Regional format:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Control Panel\International";

  Set-ItemProperty -Path $RegPath -Name "iFirstDayOfWeek" -Value "0";
  Set-ItemProperty -Path $RegPath -Name "sShortDate" -Value "yyyy-MM-dd";
  Set-ItemProperty -Path $RegPath -Name "sLongDate" -Value "dddd, d MMMM, yyyy";
  Set-ItemProperty -Path $RegPath -Name "sShortTime" -Value "HH:mm";
  Set-ItemProperty -Path $RegPath -Name "sTimeFormat" -Value "HH:mm:ss";

  Write-Host "Regional format successfully updated." -ForegroundColor "Green";
}

function Rename-PC {
  if ($env:COMPUTERNAME -ne $Config.ComputerName) {
    Write-Host "Renaming PC:" -ForegroundColor "Green";

    Rename-Computer -NewName $Config.ComputerName -Force;

    Write-Host "PC renamed, restart it to see the changes." -ForegroundColor "Green";
  }
  else {
    Write-Host "The PC name is" $Config.ComputerName "so it is not necessary to rename it." -ForegroundColor "Green";
  }
}

# Main script execution

Write-Host "Performing System Settings ... " -ForegroundColor "Yellow"
Set-WindowsExplorer-ShowFileExtensions;
Set-WindowsFileExplorer-StartFolder;
Set-Multitasking-Configuration;
Set-Classic-ContextMenu-Configuration;
Set-SetAsBackground-To-Extended-ContextMenu;
Disable-RecentlyOpenedItems-From-JumpList;
Set-Power-Configuration;
Set-Custom-Regional-Format;
Rename-PC;

Write-Host "Configuring Privacy settings ..." -ForegroundColor "Yellow"

# Don't let apps use advertising ID for experiences across apps
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
Remove-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Id" -ErrorAction SilentlyContinue

# Disable Application launch tracking
Set-ItemProperty "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start-TrackProgs" 0

# Enable SmartScreen Filter
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 1

# Disable key logging & transmission to Microsoft
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input" -Type Folder | Out-Null }
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0

# Opt-out from websites from accessing language list
Set-ItemProperty "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1

# Disable suggested content in settings app
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338394Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338396Enabled" 0

# Speech, Inking, & Typing: Stop "Getting to know me"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1

if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0

# Account Info: Don't let apps access name, picture, and other account info
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"

# Don't let apps access contacts
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny"

# Don't let apps access calendar
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" "Value" "Deny"

# Don't let apps access diagnostics of other apps
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny"

# Don't let apps access documents
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

# Don't let apps read and send email
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny"

# Don't let apps access the file system
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"

# Don't let apps access the location
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"

# Don't let apps access pictures
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

# Don't let apps access the tasks
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" "Value" "Deny"

# Don't let apps access videos
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

# Windows should never ask for my feedback
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null }
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# Send Diagnostic and usage data
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1

# Disable suggested content
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0

Write-Host "Configuring Devices, Power, and Startup..." -ForegroundColor "Yellow"

# Disable Startup Sound
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1

# Disable SuperFetch
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" 0

Write-Host "Configuring Explorer, Taskbar, and System Tray..." -ForegroundColor "Yellow"

# Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) { New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null }
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) { New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null }

# Show file extensions by default
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Avoid creating Thumbs.db files on network volumes
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Enable small icons
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

# Uninstalling and Disabling unnecessary features
# Disable Bing Search
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0

# Disable windows media player , IE, XPS printing Workffolders, windows sandbox
Disable-WindowsFeature "WindowsMediaPlayer" "Windows Media Player";
Disable-WindowsFeature "Internet-Explorer-Optional-amd64" "Internet Explorer";
Disable-WindowsFeature "Printing-XPSServices-Features" "Microsoft XPS Document Writer";
Disable-WindowsFeature "WorkFolders-Client" "WorkFolders-Client";
Enable-WindowsFeature "Containers-DisposableClientVM" "Windows Sandbox";

# Uninstalling unnecessary apps
Uninstall-AppPackage "Microsoft.Getstarted";
Uninstall-AppPackage "Microsoft.GetHelp";
Uninstall-AppPackage "Microsoft.WindowsFeedbackHub";
Uninstall-AppPackage "Microsoft.MicrosoftSolitaireCollection";

# Uninstall 3D Builder
Get-AppxPackage "Microsoft.3DBuilder" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.3DBuilder" | Remove-AppxProvisionedPackage -Online

# Uninstall Alarms and Clock
Get-AppxPackage "Microsoft.WindowsAlarms" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.WindowsAlarms" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Finance
Get-AppxPackage "Microsoft.BingFinance" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingFinance" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing News
Get-AppxPackage "Microsoft.BingNews" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingNews" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Sports
Get-AppxPackage "Microsoft.BingSports" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingSports" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Weather
Get-AppxPackage "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.BingWeather" | Remove-AppxProvisionedPackage -Online

# Uninstall Get Office, and it's "Get Office365" notifications
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.MicrosoftOfficeHub" | Remove-AppxProvisionedPackage -Online

# Uninstall Get Started
Get-AppxPackage "Microsoft.GetStarted" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "Microsoft.GetStarted" | Remove-AppxProvisionedPackage -Online

Write-Host "Configuring Default Windows Applications..." -ForegroundColor "Yellow"

# Prevent "Suggested Applications" from returning
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Type Folder | Out-Null }
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1

Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Ensure Windows Update registry paths
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Type Folder | Out-Null }

# Enable Automatic Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0

# Disable automatic reboot after install
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" "NoAutoRebootWithLoggedOnUsers" 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1

# Configure to Auto-Download but not Install: NotConfigured: 0, Disabled: 1, NotifyBeforeDownload: 2, NotifyBeforeInstall: 3, ScheduledInstall: 4
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

# Include Recommended Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1

# Opt-In to Microsoft Update
$MU = New-Object -ComObject Microsoft.Update.ServiceManager -Strict
$MU.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") | Out-Null
Remove-Variable MU

# Delivery Optimization: Download from 0: Http Only [Disable], 1: Peering on LAN, 2: Peering on AD / Domain, 3: Peering on Internet, 99: No peering, 100: Bypass & use BITS
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization")) { New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization" -Type Folder | Out-Null }
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
Set-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0

Write-Host "Configuring Windows Defender..." -ForegroundColor "Yellow"

# Disable Cloud-Based Protection: Enabled Advanced: 2, Enabled Basic: 1, Disabled: 0
Set-MpPreference -MAPSReporting 0

# Disable automatic sample submission: Prompt: 0, Auto Send Safe: 1, Never: 2, Auto Send All: 3
Set-MpPreference -SubmitSamplesConsent 2

Write-Host "Configuring Disk Cleanup..." -ForegroundColor "Yellow"

$diskCleanupRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"

# Cleanup Files by Group: 0=Disabled, 2=Enabled
Set-ItemProperty $(Join-Path $diskCleanupRegPath "BranchCache") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Downloaded Program Files") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Internet Cache Files") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Offline Pages Files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Old ChkDsk Files") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Previous Installations") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Recycle Bin") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "RetailDemo Offline Content") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Service Pack Cleanup") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Setup Log Files") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "System error memory dump files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "System error minidump files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Temporary Files") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Temporary Setup Files") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Thumbnail Cache") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Update Cleanup") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Upgrade Discarded Files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "User file versions") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Defender") "StateFlags6174" 2 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Archive Files" ) "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Queue Files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting System Archive Files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting System Queue Files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Temp Files" ) "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows ESD installation files") "StateFlags6174" 0 -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Upgrade Log Files" ) "StateFlags6174" 0 -ErrorAction SilentlyContinue

Remove-Variable diskCleanupRegPath

Write-Host "Installign Dev Packages..." -ForegroundColor "Yellow"

# Install system and cli packages
# winget install Microsoft.WebPICmd                        --silent --accept-package-agreements --accept-source-agreements
# winget install Git.Git                                   --silent --accept-package-agreements --accept-source-agreements --override "/VerySilent /NoRestart /o:PathOption=CmdTools /Components=""icons,assoc,assoc_sh,gitlfs"""
# winget install RubyInstallerTeam.Ruby.3.2                --silent --accept-package-agreements --accept-source-agreements
Write-Host "Configuring Disk Cleanup..." -ForegroundColor "Yellow"

# browsers
Write-Host "Installing Browser Packages..." -ForegroundColor "Yellow"
winget install Google.Chrome                             --silent --accept-package-agreements --accept-source-agreements
winget install Brave.Brave                               --silent --accept-package-agreements --accept-source-agreements
# winget install Mozilla.Firefox                           --silent --accept-package-agreements --accept-source-agreements
#winget install Opera.Opera                               --silent --accept-package-agreements --accept-source-agreements

# dev tools and frameworks
Write-Host "Installing Dev toosl and Framework Packages..." -ForegroundColor "Yellow"
# winget install Microsoft.PowerShell                      --silent --accept-package-agreements --accept-source-agreements
# #winget install Microsoft.SQLServer.2019.Developer        --silent --accept-package-agreements --accept-source-agreements
# winget install Microsoft.SQLServerManagementStudio       --silent --accept-package-agreements --accept-source-agreements
# #winget install Microsoft.VisualStudio.2022.Professional  --silent --accept-package-agreements --accept-source-agreements --override "--wait --quiet --norestart --nocache --addProductLang En-us --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetWeb"
# #winget install JetBrains.dotUltimate                     --silent --accept-package-agreements --accept-source-agreements --override "/SpecificProductNames=ReSharper;dotTrace;dotCover /Silent=True /VsVersion=17.0"
# winget install Vim.Vim                                   --silent --accept-package-agreements --accept-source-agreements
# #winget install WinMerge.WinMerge                         --silent --accept-package-agreements --accept-source-agreements
winget install OpenJS.NodeJS                             --silent --accept-package-agreements --accept-source-agreements
winget install Python.Python.3.12                        --silent --accept-package-agreements --accept-source-agreements

winget install Microsoft.AzureCLI                        .\.gitignore  --silent --accept-package-agreements --accept-source-agreements
winget install Amazon.AWSCLI                              --silent --accept-package-agreements --accept-source-agreements
# winget install Microsoft.Azure.StorageExplorer            --silent --accept-package-agreements --accept-source-agreements
# #winget install Microsoft.Azure.StorageEmulator            --silent --accept-package-agreements --accept-source-agreements
# #winget install Microsoft.ServiceFabricRuntime            --silent --accept-package-agreements --accept-source-agreements
winget install GitHub.GitHubDesktop                        --silent --accept-package-agreements --accept-source-agreements
winget install pCloudAG.pCloudDrive                        --silent --accept-package-agreements --accept-source-agreements
winget install Google.Drive                               --silent --accept-package-agreements --accept-source-agreements
winget install Mega.MEGASync                        --silent --accept-package-agreements --accept-source-agreements
winget install QNAP.Qsync                        --silent --accept-package-agreements --accept-source-agreements
winget install Mobatek.MobaXterm                        --silent --accept-package-agreements --accept-source-agreements


Refresh-Environment
