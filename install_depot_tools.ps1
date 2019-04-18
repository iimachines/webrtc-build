param ([string]$rootPath = $(Get-Location))
 
$zipPath = Join-Path -Path $rootPath -ChildPath "depot_tools.zip"

New-Item -ItemType Directory -Path $rootPath -Force | Out-Null

Write-Output "Downloading depot tools to $zipPath..."
(new-object System.Net.WebClient).DownloadFile('https://storage.googleapis.com/chrome-infra/depot_tools.zip', $zipPath);

Write-Output "Extracting depot tools to $rootPath..."
Expand-Archive $zipPath -DestinationPath $rootPath -Force

Write-Output "Deleting $zipPath..."
Remove-Item -Path $zipPath -Force -ErrorAction Ignore






