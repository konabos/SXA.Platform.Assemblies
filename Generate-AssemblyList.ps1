#$files = Get-ChildItem * -Include *.dll | % { $_.VersionInfo } | Select OriginalFilename, FileVersion, ProductVersionRaw, ProductVersion
#$files > sxa-list.txt

#Get-ChildItem * -Include *.dll | % { $_.VersionInfo } | Select OriginalFilename, FileVersion, ProductVersionRaw, ProductVersion | Export-Csv $outputName -NoTypeInformation


[CmdletBinding()]
Param (
    [string]
    $SourceFolder = ".\",
    
    [string]
    $TargetFile = "SXA.Platform.Assemblies.csv"
)


Write-Host "Generating Assembly list to $TargetFile ..." -ForegroundColor Yellow


Get-ChildItem -Path $SourceFolder -Recurse -Include *.dll | % { $_.VersionInfo } | `
  Select-Object -Property @{N='Filename';   E={$_.OriginalFilename}}, `
                          @{N='Version';    E={$_.FileVersion}}, `
                          @{N='FileVersion';E={$_.ProductVersionRaw}}, `
                          @{N='InfoVersion';E={$_.ProductVersion}} | ` 
  Export-Csv $TargetFile -NoTypeInformation

"sep=,`n" + (Get-Content -Path $TargetFile -Raw).replace('"','') | Set-Content -Path $TargetFile

Write-Host "Done!" -ForegroundColor Green