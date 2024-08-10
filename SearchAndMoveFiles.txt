@echo off
setlocal

:: Set the source file name
set "sourceFile=[Source File Name].docx"

:: Set the destination subdirectory
set "destDir=[Destination Subdirectory]"

:: Get the directory where the batch file is located
for %%A in ("%~dp0") do set "batchPath=%%~fA"

:: Loop through all directories in the current directory
for /D %%D in (*) do (
    :: Check if destination directory exists, if not create it
    if not exist "%%D\%destDir%" (
        mkdir "%%D\%destDir%"
    )
    
    :: Copy the source file to the destination directory
    copy /Y "%batchPath%\%sourceFile%" "%%D\%destDir%"
)

endlocal
