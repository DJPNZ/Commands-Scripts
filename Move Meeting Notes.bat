@echo off
setlocal enabledelayedexpansion

REM Set the path to the directory containing all customer folders
set "path=C:\Users\daniel.payne\ITOPS LIMITED\iTops Intranet - Itops\Clients"

REM Loop through each customer folder
for /D %%A in ("%path%\*") do (
REM Create the necessary folders if they don't exist
if not exist "%%A\Documentation\Sales" mkdir "%%A\Documentation\Sales"
if not exist "%%A\Documentation\Sales\Account Management" mkdir "%%A\Documentation\Sales\Account Management"

REM Move the Meeting Notes folder to the Documentation\Sales folder if it exist otherwise create it
if exist "%%A\Documentation\Meeting Notes" move /Y "%%A\Documentation\Meeting Notes" "%%A\Documentation\Sales"
if not exist "%%A\Documentation\Sales\Meeting Notes" mkdir "%%A\Documentation\Sales\Meeting Notes"
  
)
endlocal
