<#
  .SYNOPSIS
    Rename files and folders to lowercase recursively

  .DESCRIPTION
    Rename files and folders to lowercase recursively by specifiying (or not) a path in parameter

  .PARAMETER path
    Not mandatory, this parameter specifies the path where files will be renamed recursively
    Example: "c:/folder"

    /!\ *1
    NOTICE:
    If the parameter is not specified,
    the script will rename all the files and folders
    recursively from the current location
    /!\
#>

PARAM (
  [string]$path
)

# *1
if (!$path) {
  $path = ".";
}

Get-ChildItem $path -Recurse | Where-Object { $_.Name -cne $_.Name.ToLower() } | ForEach-Object {
  $tempName = "$($_.Name)-temp";
  $tempFullName = "$($_.FullName)-temp";
  $newName = $_.Name.ToLower();
  Rename-Item -Path $_.FullName -NewName $tempName;
  Rename-Item -Path $tempFullName -NewName $newName -Force;
};
