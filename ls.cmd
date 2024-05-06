@echo off 
setlocal enabledelayedexpansion
chcp 65001>nul
set red=[91m
set yellow=[93m
set green=[92m
set blue=[94m
set purple=[95m
set cyan=[96m
set white=[97m
set reg=[0m
set dkpurple=[35m
set dkblue=[34m
set grey=[90m
set currentFile=%~n0%~x0
set nameonly=%~n0
:start_file
if "%1" == "-ex" goto expand
if "%1" == "--expand" goto expand
if "%1" == "-tr" goto tree
if "%1" == "--legacy" goto tree
if "%1" == "" goto basic
if "%1" == "-help" (
    if "%2" == "-ex" (
        goto helpexpand
    )
    if "%2" == "-bd" (
        goto helpbreak
    ) 
    goto help
)
if "%1" == "-nt" goto neat
if "%1" == "--neat" goto neat
if "%1" == "-gr" goto graphical
if "%1" == "-sbf" (
    :: verify if a second arguement is given
    if not "%2" == "" (
        set "filetype=%2"
        goto searchbyfile
    ) else (
        echo ls: Invalid Structure. no [FILETYPE] arguement given
        echo ls: Please Try "%nameonly% -help"
        goto eof
    )
)
if "%1" == "-bd" (
    if not "%2" == "" (
        set "targetfilename=%2"
        goto filebd
    ) else (
        echo ls: Invalid Structure. no [FILE] arguement given
        echo ls: Please Try "%nameonly% -help"
        goto eof
    )
)


goto invalid

rem basic lists

:basic
rem Set current directory name
for %%I in ("%CD%") do set "currentDirName=%%~nI"
set "directory=%cd%"

rem List all files in the specified directory
set "files="
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%"2^>nul') do (
    set "files=!files!  %%F"
)
if %errorlevel%==1 set "files="

rem List all directories in the specified directory
set "directories="
for /f "delims=" %%D in ('dir /b /ad "%directory%"2^>nul') do (
    set "directories=!directories!  %%D"
)
echo %grey%%files%%dkblue%%directories%%reg%
goto EOF


rem -expand, shows every inch of detail

:expand
rem Set current directory name
for %%I in ("%CD%") do set "currentDirName=%%~nI"

rem Set directory path
set "directory=%CD%"

rem List all files and directories in the specified directory
echo.
echo %reg%📂 %white%%cd%%reg%
echo  %grey%│
set /a counter=0
set /a totalsize=0
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%"2^>nul') do (
    rem Get file size and creation date
    for %%A in ("%directory%\%%F") do (
        set "fileSize=%%~zA"
        set "fileCreationDate=%%~tA"
        set /a counter += 1
        set /a totalsize+=!fileSize!
    )
    if errorlevel == 0 (
    echo %grey%!counter!│ %red%%currentDirName% %yellow%%%F %green%!fileSize!%grey%B %blue%!fileCreationDate:~0,10! %purple%%cd%\%%F %reg%
    ) 
)

rem List all directories in the specified directory
for /f "delims=" %%D in ('dir /b /ad "%directory%"2^>nul') do (
    set "dirSize=0"
    rem Iterate through files in the directory and accumulate their sizes
    for %%A in ("%directory%\%%D") do (
        set "fileCreationDate=%%~tA"
    )
    for /f "tokens=3" %%S in ('dir /s /-c "%%D\*" ^| findstr /r /c:"bytes$"') do (
        set /a "dirSize+=%%S"
    )
    set /a totalsize+=!dirSize!
    set /a counter+=1
    if errorlevel == 0 (
    echo %grey%!counter!│ %red%%currentDirName% %yellow%%%D %green%!dirSize!%grey%B %blue%!fileCreationDate:~0,10! %dkpurple%%cd%\%%D\ %reg%
    )
)
rem do some math
set /a gb=!totalsize! / 1000000000
echo  %grey%└───%grey%TC:%green%!counter! %grey%TS:%green%!totalsize!%grey%B%reg% %grey%TS:%green%!gb!%grey%GB%reg%
goto eof


:tree
for %%I in ("%CD%") do set "currentDirName=%%~nI"
    set "directory=%cd%"
rem List all files and directories in the specified directory
echo 📂 %white%%cd%
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%"2^>nul') do (
    echo %white%├─📄 %brightwhite%%%F
)
rem List all directories in the specified directory
for /f "delims=" %%D in ('dir /b /ad "%directory%"2^>nul') do (
    echo %white%├─%brightwhite%📁 %%D %reg%
)
goto eof

:neat
for %%I in ("%CD%") do set "currentDirName=%%~nI"
    set "directory=%cd%"
echo.
set /a counter=0
rem List all files and directories in the specified directory
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%"2^>nul') do (
    set /a counter+=1
    echo %grey%!counter! %white%%%F
)
rem List all directories in the specified directory
for /f "delims=" %%D in ('dir /b /ad "%directory%"2^>nul') do (
    set /a counter+=1
    echo %grey%!counter! %white%%%D
)
echo.
echo %green%Total Files !counter!%reg%
goto eof

:graphical
cls
echo.
echo ╔═╗╦  ╔═╗  Your Goto 
echo ╠╣ ║  ╚═╗  CLI File
echo ╚  ╩═╝╚═╝  Explorer
echo.  
echo [1] - Normal List
echo [2] - Extra List
echo [3] - Neat List
echo [4] - FLS Legacy List
echo.
echo [0] - Exit
set choice=9
set /p choice=
if %choice%==1 goto basic
if %choice%==2 goto expand
if %choice%==3 goto neat
if %choice%==4 goto tree
if %choice%==0 goto eof
goto graphical

:invalid
echo %reg%ls: Invalid [OPTION] Arguement(s) Given
echo ls: Please Try "fls -help"
goto eof
echo.
:help 
echo.
echo Listing Your Files Inside Your Terminal 
echo Lists files inside the current directory by default
::echo Made By %green%Saaim Japanwala%reg%
echo.             
echo Usage: %nameonly% [OPTION]... [FILE]...
echo.
echo OPTIONS: Options are required for a customized view, else will show basic ls listing.
echo    -ex, --expand                expandable  info, shows brief information about the file (listed)
echo                                 (format for -ex: rootdirname filename filesize(B) editdate rootpath)
echo.
echo    -nt, --neat                  neat, neatly organizes all the files in a horizontal list
echo.
echo    -tr,  --legacy               legacy, miniature file tree/legacy (better alternative is windows "tree" command)
echo.
echo    -sbf, --searchbyfile         search by file, shows only files with the specific file extention. 
echo                                 REQUIRES FILETYPE ARG IN PLACE OF FILE ARG (.txt, .cmd, .json, etc...)
echo.
echo    -bd, --breakdown            file breakdown, shows a whole lot of information about a specific file.
echo                                REQUIRES FILE ARG IN PLACE OF FILE ARG (please include file ext to reduce ambiguity)
echo.
echo OTHER: Other commands that are for management, and other cases.
echo    -help       shows help menu, Usage: ls -help [OTHER]
echo                -^> with no args, will shows general help
echo                -^> [-a]    help about everything
echo                -^> Specific Command Help (ls -help [-command])
echo.
goto eof

:searchbyfile
for %%I in ("%CD%") do set "currentDirName=%%~nI"
    set "directory=%cd%"
rem List all files and directories in the specified directory
echo %reg%Searching for %green%%filetype%%reg% file types in directory %green%%currentDirName%%reg%
echo.
set filefound=False
set counter=0
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%\*%filetype%"2^>nul') do (
    set filefound=True
    set /a counter+=1
    echo %grey%!counter! │ %reg%%%F%reg%
)

if %filefound%==False (
    echo No %green%%filetype%%reg% file types were found.
)
goto eof

:filebd
:: search for the specific file
:: this is the info extractor
set filelister=0
if exist %targetfilename% (
    echo  %reg%File Found [%green%%targetfilename%%reg%]
    echo.
    goto extractinfo
) else (
    echo ls: Locate Error!
    echo ls: There was no such file [%targetfilename%].
    goto eof
)
:extractinfo
echo  %grey%│ %reg%Showing Properties For %targetfilename%
echo  %grey%├─────────────────────────
::file name
set /a filelister+=1
echo %grey%!filelister!│ %red%File Name    %reg%%targetfilename%
:: file extention
set /a filelister+=1
for %%A in ("%targetfilename%") do (
    echo %grey%!filelister!│ %red%File Type    %reg%%%~xA
) 
:: file path
set /a filelister+=1
echo %grey%!filelister!│ %red%File Path    %reg%%cd%\%targetfilename%
:: file data info
for %%A in ("%cd%\%targetfilename%") do (
    set "fileSize=%%~zA"
    set "fileCreationDate=%%~tA"
    set /a counter += 1
    set /a totalsize+=!fileSize!
)
set /a filelister+=1
echo %grey%!filelister!│ %red%File Size    %reg%!fileSize! Bytes
set /a filelister+=1
echo %grey%!filelister!│ %red%Edit Date    %reg%!fileCreationDate!
:: find file perms
for /f "usebackq delims=" %%I in (`powershell -command "(Get-Acl '%targetfilename%').Owner"`) do set "file_owner=%%I"
set /a filelister+=1
echo %grey%!filelister!│ %red%File Owner   %reg%!file_owner!
:: find if file is hidden
set /a filelister+=1
for /f "tokens=2 delims= " %%a in ('attrib %targetfilename%') do (
    if "%%a"=="H" (
        echo %grey%!filelister!│ %red%Appearance   %reg%Hidden
    ) else (
        echo %grey%!filelister!│ %red%Appearance   %reg%Not Hidden
    )
)
echo  %grey%└─%reg%
goto eof

:helpexpand
echo Usage: ls -ex
echo Usage: ls --expand
echo.
echo Description,
echo    Expand function displays various types of data for the user to see.
echo    including Root File, File Name, File Size (B, GB), Date Edited, and Path
echo.
echo Model,
echo.
echo    %grey%   📂 C:\(Your Directory)
echo    %grey%   │
echo    %grey% 1 │ %red%Root Folder%reg% %yellow%File Name%reg% %green%File Size%reg% %blue%Date Created/Edited%reg% %purple%Path (file)%reg%
echo    %grey% 2 │ %red%Root Folder%reg% %yellow%File Name%reg% %green%File Size%reg% %blue%Date Created/Edited%reg% %dkpurple%Path (dir)%reg%
echo    %grey%   └───TC:%green%(Total Content) %grey%TS:%green%(Total Size Bytes) %grey%TS:%green%(Total Size GigaBytes)%reg%
echo.
goto eof
:helpbreak
echo Usage: ls -bd [FILE]
echo Usage: ls --breakdown [FILE]
echo.
echo [FILE] = Your file name (main.py, index.html, etc)
echo.
echo Description,
echo    Get your file data right in your terminal, with details about its attributes
echo.
echo Model,     (this file doesnt exist, its a demo)
echo.
echo     %grey% │ %reg%Showing Properties For TestFile.cmd
echo     %grey% ├─────────────────────────
echo     %grey%1│ %red%File Name    %reg%TestFile.cmd
echo     %grey%2│ %red%File Type    %reg%.cmd
echo     %grey%3│ %red%File Path    %reg%C:\Users\%username%\Downloads\TestFile.cmd
echo     %grey%4│ %red%File Size    %reg%12678 Bytes
echo     %grey%5│ %red%Edit Date    %reg%09/11/2001 04:40 PM
echo     %grey%6│ %red%File Owner   %reg%%computername%\%username%
echo     %grey%7│ %red%Appearance   %reg%Not Hidden
echo     %grey% └─%reg%
:eof
