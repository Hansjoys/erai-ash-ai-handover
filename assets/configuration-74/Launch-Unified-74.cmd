@echo off
setlocal
cd /d "%~dp0"
set /p G=Greatshield count (1-5): 
set /p W=Lone Wolf count (1-3): 
set "PW7=<USER_HOME>\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe"
if not exist "%PW7%" (echo STOP: trusted PowerShell 7 runtime not found&pause&exit /b 1)
"%PW7%" -NoLogo -NoProfile -File "%~dp0Validate-Unified-74.ps1" -GreatshieldCount %G% -LoneWolfCount %W%
if errorlevel 1 (echo UNIFIED74 NOT LAUNCHED - preflight failed. No game was started.&pause&exit /b 1)
set "OUT=%~dp0launcher-output-%G%-%W%.txt"
echo UNIFIED74 LAUNCH REQUEST Greatshield=%G% LoneWolf=%W% %DATE% %TIME%>"%OUT%"
"<USER_HOME>\AppData\Local\ERAI-UserTests\me3-0.13.0\bin\me3.exe" --crash-reporting=false --profile-dir "%~dp0profile-%G%-%W%" launch --game eldenring --exe "<GAME_ROOT>\RING\Game\eldenring.exe" --profile "%~dp0generated\greatshield-%G%-lone-wolf-%W%\profile\erai-unified-%G%-%W%.me3" --online=false --disable-arxan=false --skip-steam-init=false >>"%OUT%" 2>&1
set "RC=%ERRORLEVEL%"
echo UNIFIED74 ME3_EXITCODE %RC%>>"%OUT%"
pause
exit /b %RC%
