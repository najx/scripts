<#
  .SYNOPSIS
    Script for traversing a directory and writing file information and contents to an output file.

  .DESCRIPTION
    This script traverses a specified directory, checks whether the items are files or folders,
    and writes this information along with the contents of the files to an output file.
    The script also allows for filtering files based on their extension.

  .PARAMETER path
    Mandatory, this parameter specifies the path where directories and files are stored.
    Example: "c:/folder"

  .PARAMETER outputFile
    Mandatory, this parameter specifies the path of the file where the output will be written.
    Example: "c:/output.txt"

  .PARAMETER filterExtension
    Optional, this parameter allows filtering files based on their extension.
    Default is "*", meaning all files will be included.
    Example: "txt"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$path,

    [Parameter(Mandatory=$true)]
    [string]$outputFile,

    [Parameter(Mandatory=$false)]
    [string]$filterExtension = "*"
)

# Check if the path exists
if (!(Test-Path $path)) {
    Write-Error "The specified path does not exist"
    exit 1
}

# Create the output file if it does not exist
if (!(Test-Path $outputFile)) {
    New-Item -Path $outputFile -ItemType File -Force
} else {
    Remove-Item -Path $outputFile -Force -Verbose
    New-Item -Path $outputFile -ItemType File -Force
}

# Get the items in the directory respecting the extension filter
Get-ChildItem -Path $path -Recurse -Filter "*.$filterExtension" | ForEach-Object {

    # Check if the object is a file
    if ($_.PSIsContainer -eq $false) {
        # Add the full path of the file to the output file
        Add-Content -Path $outputFile -Value "Content of the file: $($_.FullName)"
        Add-Content -Path $outputFile -Value ""
        Add-Content -Path $outputFile -Value "````````"
        
        # Add the content of the file to the output file
        Get-Content $_.FullName | ForEach-Object {
            Add-Content -Path $outputFile -Value $_
        }
        
        Add-Content -Path $outputFile -Value "````````"
        Add-Content -Path $outputFile -Value ""
    } else {
        # Add the full path of the directory to the output file
        Add-Content -Path $outputFile -Value "Directory: $($_.FullName)"
    }
}
