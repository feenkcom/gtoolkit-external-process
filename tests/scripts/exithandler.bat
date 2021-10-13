@echo off
rem Batch script to run the powershell script\
rem So that the commands are the same on Unix and Windows
SET script_dir=%~dp0
powershell.exe -file %script_dir%exithandler.ps1 %1
exit %ERRORLEVEL%