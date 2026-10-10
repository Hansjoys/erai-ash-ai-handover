@echo off
setlocal
set "PW7=<USER_HOME>\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe"
if not exist "%PW7%" (echo STOP: trusted PowerShell 7 runtime not found&pause&exit /b 1)
"%PW7%" -NoLogo -NoProfile -File "%~dp0Configure-ERAI.ps1" -Interactive
if errorlevel 1 (echo CONFIGURATION FAILED - no launch performed&pause&exit /b 1)
echo Configuration saved to %~dp0selection.json
pause
exit /b 0
