
$profileDir = $PSScriptRoot;
$env:POWERSHELL_UPDATECHECK = 'Off'


# From https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil#97599
function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
	(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

# From http://stackoverflow.com/questions/7330187/how-to-find-the-windows-version-from-the-powershell-command-line
function get-windows-build {
    [Environment]::OSVersion
}

function get-path {
	($Env:Path).Split(";")
}


# Functions
function get-serial-number {
    Get-CimInstance -ClassName Win32_Bios | select-object serialnumber
}
  
function get-process-for-port($port) {
    Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
}

function open($file) {
    invoke-item $file
}
  
function explorer {
    explorer.exe .
}
function settings {
    start-process ms-setttings:
}
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

function rename-extension($newExtension) {
    Rename-Item -NewName { [System.IO.Path]::ChangeExtension($_.Name, $newExtension) }
}
function edit {
    & "code" -g @args
}

# Aliases
set-alias unzip expand-archive
Set-Alias trash Remove-ItemSafely

# Modules

# Git integration like tab completion
Import-Module posh-git

# Proper history etc
#Import-Module PSReadLine
#Import-Module -Name Terminal-Icons

# CONFIGS
# Produce UTF-8 by default
# https://news.ycombinator.com/item?id=12991690
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

# https://technet.microsoft.com/en-us/magazine/hh241048.aspx
$MaximumHistoryCount = 10000;

# Oddly, Powershell doesn't have an inbuilt variable for the documents directory. So let's make one:
# From https://stackoverflow.com/questions/3492920/is-there-a-system-defined-environment-variable-for-documents-directory
$env:DOCUMENTS = [Environment]::GetFolderPath("mydocuments")


foreach ( $includeFile in ( "openssl", "unix") ) {
    Unblock-File $profileDir\$includeFile.ps1
    . "$profileDir\$includeFile.ps1"
}

Write-Output "Profile loaded"