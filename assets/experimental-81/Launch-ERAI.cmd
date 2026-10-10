@echo off
setlocal
set "PW7=<USER_HOME>\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\powershell\pwsh.exe"
if not exist "%PW7%" (echo STOP: trusted PowerShell 7 runtime not found&pause&exit /b 1)
"%PW7%" -NoLogo -NoProfile -File "%~dp0Launch-ERAI.ps1"
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" (echo ERAI81 launch/preflight failed. No configuration was changed.&pause)
exit /b %RC%
