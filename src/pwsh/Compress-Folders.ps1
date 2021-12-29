<#
  .SYNOPSIS
    Compress files contained onto a source directory

  .DESCRIPTION
    Compress files contained onto a source directory by specifying the destination of compressed files

  .PARAMETER source
    Specifies the extension. example: "c:/folder"

  .PARAMETER destination
    Specifies the destination of compressed files. "c:/temp"
#>

PARAM (
  [string]$source,
  [string]$destination
)

$directories_to_compress = Get-ChildItem -Path $source;

# Check if the destination folder exists otherwise it's created..
if (!(test-path -Path $destination)) {
  [void](New-Item -Type Directory -Path $destination);
}

# In the $destination directory, the script will generate an archive for all the items found in $source folder
foreach ($_ in $directories_to_compress) {
  Write-Host $_.name -ForegroundColor Green;
  $compress = @{
    Path = $_ # "c:/xyz/abc"
    CompressionLevel = "Fastest"
    DestinationPath = $destination+"\$($_.name).Zip"
  }
  Compress-Archive @compress;
}
