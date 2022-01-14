<#
  .SYNOPSIS
    Pull remote Git repositories locally
  .DESCRIPTION
    Pull a remote list of Git repositories
    locally by specifying the path where
    are listed directories
  .PARAMETER path
    Mandatory, this parameter specifies the
    path where directories are stored
      Example: "c:/folder"
#>

param (
  [string]$path
)

if ($path) {
  $repositoriesToPull = Get-ChildItem -Path $path;
  foreach ($repository in $repositoriesToPull) {
    $fileToCheck = Join-Path -Path $repository -ChildPath "\.git";
    if (Test-Path -Path $fileToCheck) {
      Write-Host "Pulling this repository --> $repository" -ForegroundColor Magenta;
      git -C $repository checkout master;
      git -C $repository branch;
      git -C $repository pull;
    } else {
      Write-Host "  $repository is not a git repository..." -ForegroundColor DarkGray;
    }
  }
} else {
  Write-Error "No parameter (path) specified...";
  Write-Error "Retry by specifying a path...";
}
