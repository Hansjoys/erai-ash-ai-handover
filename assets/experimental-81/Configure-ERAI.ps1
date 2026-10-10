param([ValidateRange(1,5)][int]$GreatshieldCount,[ValidateRange(1,3)][int]$LoneWolfCount,[switch]$Interactive)
$ErrorActionPreference='Stop';$root='<ERAI_ROOT>\work\erai-usable-experimental-81';$source='<ERAI_ROOT>\work\summon-baseline-50\AI_SUMMON_BASELINE';$plain=Join-Path $source 'expected.bnd4';$sourcePkg=Join-Path $source 'package\regulation.bin';$library='<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Andre.SoulsFormats.dll';$defs='<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b\Assets\PARAM\ER\Defs';$gameReg='<GAME_ROOT>\RING\Game\regulation.bin'
function Hash74([byte[]]$d){$s=[Security.Cryptography.SHA256]::Create();try{([BitConverter]::ToString($s.ComputeHash($d))).Replace('-','')}finally{$s.Dispose()}}
function FH74([string]$p){Hash74 ([IO.File]::ReadAllBytes($p))}
function WriteNew74([string]$p,[byte[]]$d){[IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($p))|Out-Null;$f=[IO.File]::Open($p,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None);try{$f.Write($d,0,$d.Length)}finally{$f.Dispose()}}
function SaveSelection81([string]$artifact,[string]$outRoot,[int]$g,[int]$w,[string]$profileDir){$sel=[ordered]@{greatshield=$g;lone_wolf=$w;package=$artifact;package_sha256=(FH74 $artifact);profile=(Join-Path $profileDir "erai-unified-$g-$w.me3");status="OFFLINE_VALIDATED"};[IO.File]::WriteAllText((Join-Path $outRoot "selection.json"),($sel|ConvertTo-Json),[Text.UTF8Encoding]::new($false))}
if($Interactive){$GreatshieldCount=[int](Read-Host 'Greatshield count (1-5)');$LoneWolfCount=[int](Read-Host 'Lone Wolf count (1-3)')}
if($GreatshieldCount -lt 1 -or $GreatshieldCount -gt 5){throw 'Greatshield count must be 1..5'};if($LoneWolfCount -lt 1 -or $LoneWolfCount -gt 3){throw 'Lone Wolf count must be 1..3'}
if(!(Test-Path $plain)-or!(Test-Path $sourcePkg)){throw 'source incomplete'};if((FH74 $sourcePkg)-cne 'D3C90B8E4BDB4699E0C8D13DC23CAB050AC4CDA6413937C450E79342EB6F658F'){throw 'source package hash mismatch'};if((FH74 $plain)-cne 'B1D2D909F5AA3490311CF27627B037DFA495E24DA1545CA6616CFCBBB9FECFCD'){throw 'source plaintext hash mismatch'};if((FH74 $gameReg)-cne '766521F9508DE3A3532DF61C45A1C2D93340F1FF7ED8306AB20DF761712CA2AB'){throw 'original regulation changed'};if($PSVersionTable.PSVersion.Major-lt 7){throw 'PowerShell 7 required'};if((FH74 $library)-cne '854742628B9054E94FCE9790364BE8E13396649E73BDD6C63FB592B44C9257D3'){throw 'library hash mismatch'}
$env:PATH='<GAME_ROOT>\Smithbox_2_2_6_2026_09_20_b;'+$env:PATH;[void][Reflection.Assembly]::LoadFrom($library);$bd=[SoulsFormats.PARAMDEF]::XmlDeserialize((Join-Path $defs 'BuddyParam.xml'),$true).GetFilteredParamdefForRegulationVersion([UInt64]11711000);$base=[SoulsFormats.BND4]::Read([IO.File]::ReadAllBytes($plain));if($base.Version-ne '11711000'-or$base.Files.Count-ne 194){throw 'BND mismatch'};$bf0=@($base.Files|?{[IO.Path]::GetFileNameWithoutExtension($_.Name)-ceq 'BuddyParam'})[0];$p0=[SoulsFormats.PARAM]::Read($bf0.Bytes.ToArray());$p0.ApplyParamdef($bd);$greatIds=@(24800000,24800001,24800002,24800003,24800004);$wolfIds=@(23200000,23200001,23200002);$great=@($p0.Rows|?{$greatIds-contains[int]$_.ID});$wolf=@($p0.Rows|?{$wolfIds-contains[int]$_.ID});if($great.Count-ne 5-or$wolf.Count-ne 3){throw 'target groups incomplete'};foreach($r in $great){if([int]$r['npcParamId'].Value-ne170001000-or[int]$r['npcThinkParamId'].Value-ne270001001){throw 'greatshield identity mismatch'}};foreach($r in $wolf){if([int]$r['npcParamId'].Value-ne140700000-or[int]$r['npcThinkParamId'].Value-ne140700000){throw 'wolf identity mismatch'}}
$name="greatshield-$GreatshieldCount-lone-wolf-$LoneWolfCount";$outRoot=Join-Path $root "generated\$name";$pkg=Join-Path $outRoot 'package';$profile=Join-Path $outRoot 'profile';$artifact=Join-Path $pkg 'regulation.bin';if(Test-Path $artifact){Write-Output "REUSED=$artifact";Write-Output "PACKAGE_SHA256=$(FH74 $artifact)";SaveSelection81 $artifact $root $GreatshieldCount $LoneWolfCount $profile;exit 0}
$bnd=[SoulsFormats.BND4]::Read([IO.File]::ReadAllBytes($plain));$bf=@($bnd.Files|?{[IO.Path]::GetFileNameWithoutExtension($_.Name)-ceq 'BuddyParam'})[0];$bp=[SoulsFormats.PARAM]::Read($bf.Bytes.ToArray());$bp.ApplyParamdef($bd);$remove=@($greatIds|?{$_-ge(24800000+$GreatshieldCount)});$remove+=@($wolfIds|?{$_-ge(23200000+$LoneWolfCount)});foreach($id in $remove){$row=@($bp.Rows|?{[int]$_.ID-eq$id});if($row.Count-ne1){throw "missing row $id"};[void]$bp.Rows.Remove($row[0])};$bf.Bytes=[Memory[byte]]::new($bp.Write());$iv=[IO.File]::ReadAllBytes($gameReg)[0..15];$enc=[SoulsFormats.SFUtil]::EncryptERRegulation($bnd,[byte[]]$iv,[SoulsFormats.DCX+Type]::DCX_ZSTD);WriteNew74 $artifact $enc
$text=@"
profileVersion = "v1"
start_online = false
disable_arxan = false
natives = []

[[supports]]
game = "eldenring"

[[packages]]
id = "erai-unified-$GreatshieldCount-$LoneWolfCount"
path = '$pkg'
enabled = true

[game.eldenring]
exe = '<GAME_ROOT>\RING\Game\eldenring.exe'
skip_steam_init = false
"@;[IO.Directory]::CreateDirectory($profile)|Out-Null;[IO.File]::WriteAllText((Join-Path $profile "erai-unified-$GreatshieldCount-$LoneWolfCount.me3"),$text,[Text.UTF8Encoding]::new($false));$dec=[SoulsFormats.SFUtil]::DecryptERRegulation($artifact);$dbf=@($dec.Files|?{[IO.Path]::GetFileNameWithoutExtension($_.Name)-ceq 'BuddyParam'})[0];$dp=[SoulsFormats.PARAM]::Read($dbf.Bytes.ToArray());$dp.ApplyParamdef($bd);if(@($dp.Rows|?{$greatIds-contains[int]$_.ID}).Count-ne$GreatshieldCount-or@($dp.Rows|?{$wolfIds-contains[int]$_.ID}).Count-ne$LoneWolfCount){throw 'roundtrip count mismatch'};Write-Output "GENERATED=$artifact";Write-Output "PACKAGE_SHA256=$(FH74 $artifact)";SaveSelection81 $artifact $root $GreatshieldCount $LoneWolfCount $profile;Write-Output 'GAME_TESTED=false'
