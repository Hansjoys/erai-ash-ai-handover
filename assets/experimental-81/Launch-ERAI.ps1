$ErrorActionPreference='Stop'
$root=$PSScriptRoot
$log=Join-Path $root 'launcher-output-81.txt'
try {
  & (Join-Path $root 'Validate-ERAI.ps1')
  $sel=Get-Content (Join-Path $root 'selection.json') -Raw | ConvertFrom-Json
  $me3='<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe'
  if(!(Test-Path -LiteralPath $me3)){throw "me3 executable not found: $me3"}
  $runtime=Join-Path $root 'me3-runtime-profile'
  New-Item -ItemType Directory -Path $runtime -Force | Out-Null
  Add-Content -LiteralPath $log -Value ("ERAI81 LAUNCH REQUEST Greatshield=$($sel.greatshield) LoneWolf=$($sel.lone_wolf) $(Get-Date -Format o)")
  Add-Content -LiteralPath $log -Value ("package=$($sel.package)`npackage_sha256=$($sel.package_sha256)`nprofile=$($sel.profile)")
  & $me3 --crash-reporting=false --profile-dir $runtime launch --game eldenring --exe '<GAME_ROOT>\RING\Game\eldenring.exe' --profile ([string]$sel.profile) --online=false --disable-arxan=false --skip-steam-init=false 2>&1 | Tee-Object -FilePath $log -Append
  $rc=$LASTEXITCODE
  Add-Content -LiteralPath $log -Value "ERAI81 ME3_EXITCODE $rc"
  if($rc -ne 0){ Write-Host "ERAI启动失败：me3返回码 $rc。详见 $log"; Read-Host '按回车关闭'; exit $rc }
  exit 0
}
catch {
  Add-Content -LiteralPath $log -Value ("ERAI81 ERROR: " + $_.Exception.Message)
  Write-Host ("ERAI启动前检查失败：" + $_.Exception.Message)
  Write-Host ("日志：" + $log)
  Read-Host '按回车关闭'
  exit 1
}
