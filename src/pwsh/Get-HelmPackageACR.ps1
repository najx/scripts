<#
  .SYNOPSIS
    Get list (10 images - can be adjusted line 29) of helm packages stored in one Azure Container Registry

  .DESCRIPTION
    Get list of helm packages stored in one Azure Container Registry.
    Supposed your repository follow this naming convention:

      - helm-dev/service2
      - helm-dev/service3
      - helm-qa/service2
      - helm-qa/service3

    You can add some more values and improve the script as you want/need.

  .PARAMETER env
    Specifies the env. Can be "dev, qa, all"
      example: "c:/folder"
#>

param (
  $env
)

function checkTags {
  param ($val)
  if ($val) { $val = "-$val"};

  $repositories = (az acr repository list --name <NAME> -o tsv); # <NAME> is ACR Repository Name
  foreach ($_ in $repositories) {
    if ($_ -match "helm$val" ) {
      Write-Host "-> $_" -ForegroundColor Cyan -BackgroundColor DarkBlue -NoNewline;
      Write-Host "";
      az acr repository show-tags -n cronedimensionalpi `
                                  --repository $_ `
                                  --top 10 `
                                  --orderby time_desc `
                                  --detail `
                                  -o table;
      Write-Host "";
      Write-Host "";
    }
  }
}

switch ($env) {
  "dev" { checkTags -val "dev"; }
  "qa"  { checkTags -val "qa";  }
  "all" { checkTags -val "";    }
  default {
    Write-Host "/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_" -ForegroundColor Red;
    Write-Host "Need to specify one parameter at least" -ForegroundColor Red;
    Write-Host " -env (dev/qa/all) " -ForegroundColor Red;
    Write-Host "      ---- " -ForegroundColor Red;
    Write-Host "/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_" -ForegroundColor Red;
  }
}
