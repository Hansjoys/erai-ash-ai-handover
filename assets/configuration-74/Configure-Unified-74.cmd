@echo off
setlocal
cd /d "%~dp0"
set "PW7=<USER_HOME>\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe"
if not exist "%PW7%" (echo STOP: trusted PowerShell 7 runtime not found&pause&exit /b 1)
"%PW7%" -NoLogo -NoProfile -File "%~dp0Configure-Unified-74.ps1" -Interactive
pause
