:: This script was originally used to loop through over 150 customer directories looking for their meeting notes directory.
:: If found, it would then move it to a new location (we were restructuring directories).
:: If not found (some customers had no meeting notes, and therefore no meeting notes directory), it would create the meeting notes directory in the new location.

@echo off
setlocal enabledelayedexpansion

REM Set the path to the directory containing all destination directories
set "path=[Destination Directories Path]"

REM Loop through each destination
for /D %%A in ("%path%\*") do (
REM Create the necessary folders if they don't exist
if not exist "%%A\[Folder to be created]" mkdir "%%A\[Folder to be created]"
if not exist "%%A\[Folder to be created]" mkdir "%%A\[Folder to be created]"

REM Move a directory and its contents to another directory if it exist otherwise create the directory structure
if exist "%%A\[Destination Folder]" move /Y "%%A\[Folder to move]" "%%A\[Destination Folder]"
if not exist "%%A\[Destination Folder]" mkdir "%%A\[Destination Folder]\[New Folder]"
  
)
endlocal
