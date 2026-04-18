@echo off
:: GeminiCat Windows Setup - Double-click to run

cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
pause
