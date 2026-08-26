@echo off
rem Double-click this file to back up the latest .html into the backup folder.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup.ps1"
pause
