# Git integration like tab completion
if ( -Not (Get-Module -ListAvailable -Name posh-git)) {
    Install-Module posh-git
    
}
Import-Module posh-git