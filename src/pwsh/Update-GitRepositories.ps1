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
  [string]$path,
  [string]$exclude
)

if ($path) {
  $repositoriesToPull = Get-ChildItem -Path $path;
  foreach ($repository in $repositoriesToPull) {
    $fileToCheck = Join-Path -Path $repository -ChildPath "\.git";
    if (Test-Path -Path $fileToCheck) {
      $excludedRepo = Split-Path -Path $repository -Leaf;
      if ($exclude -eq $excludedRepo) {
        Write-Host "Repository ($repository)-excluded ... " -ForegroundColor Cyan;
      } else {
        Write-Host "Repository ($repository) is updating ..." -ForegroundColor Green;
        git -C $repository branch;
        git -C $repository checkout dev;
        git -C $repository pull;
        git -C $repository branch;
      }
    } else {
      Write-Host "Repository ($repository) isn't a valid git repository..." -ForegroundColor DarkGray;
    }
  }
} else {
  Write-Error "No parameter (path) specified...";
  Write-Error "Retry by specifying a path...";
}
