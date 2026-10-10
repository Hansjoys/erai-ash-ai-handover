param()
$ErrorActionPreference='Stop'
$root=$PSScriptRoot;$selPath=Join-Path $root 'selection.json';$game='<GAME_ROOT>\RING\Game\eldenring.exe';$me3='<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe'
if(!(Test-Path $selPath)){throw 'selection.json missing - run Configure-ERAI.cmd first'}
$sel=Get-Content $selPath -Raw|ConvertFrom-Json
if([int]$sel.greatshield -notin 1..5 -or [int]$sel.lone_wolf -notin 1..3){throw 'selection range invalid'}
$pkg=[string]$sel.package;$profile=[string]$sel.profile
if(!(Test-Path $pkg)-or!(Test-Path $profile)){throw 'selected package/profile missing'}
$actual=(Get-FileHash -Algorithm SHA256 $pkg).Hash;if($actual -cne [string]$sel.package_sha256){throw 'selected package hash mismatch'}
$pt=Get-Content $profile -Raw
if($pt -notmatch '(?m)^start_online\s*=\s*false\s*$'){throw 'start_online must be false'}
if($pt -notmatch '(?m)^natives\s*=\s*\[\s*\]\s*$'){throw 'natives must be []'}
$pkgDir=Split-Path -Parent $pkg
if($pt -notmatch [regex]::Escape($pkgDir)){throw 'profile does not reference selected package directory'}
if(!(Test-Path $game)-or!(Test-Path $me3)){throw 'game or C me3 missing'}
$gv=(Get-Item $game).VersionInfo.ProductVersion;if($gv -ne '2.7.1.0'){throw "unexpected game version: $gv"}
$gh=(Get-FileHash -Algorithm SHA256 $game).Hash;if($gh -cne '1A3547101327F65D0C76DA2F9190AC0AA66871EA42BAE2AECC61E11A8B597891'){throw 'game SHA256 mismatch'}
if(@(Get-Process -Name eldenring,me3,me3-launcher -ErrorAction SilentlyContinue).Count){throw 'existing Elden Ring/me3 process detected'}
Write-Output 'ERAI81 PREFLIGHT PASS';Write-Output "Greatshield=$($sel.greatshield) LoneWolf=$($sel.lone_wolf)";Write-Output "PACKAGE=$pkg";Write-Output "PACKAGE_SHA256=$actual";Write-Output "PROFILE=$profile";Write-Output 'start_online=false';Write-Output 'natives=[]';Write-Output 'GAME_LAUNCH=MANUAL_USER_ONLY'
