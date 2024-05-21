@echo off 
setlocal enabledelayedexpansion
chcp 65001>nul
set version=0.1
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
if "%1" == "-r" goto recur
if "%1" == "--recursive" goto recur
if "%1" == "-ex" goto expand
if "%1" == "--expand" goto expand
if "%1" == "-tr" goto tree
if "%1" == "--legacy" goto tree
if "%1" == "" goto basic
if "%1" == "--help" (
    if "%2" == "-ex" (
        goto helpexpand
    )
    if "%2" == "-bd" (
        goto helpbreak
    ) 
    if "%2" == "-ls" (
        goto helpls
    )
    goto help
)
if "%1" == "-?" (
    if "%2" == "-ex" (
        goto helpexpand
    )
    if "%2" == "-bd" (
        goto helpbreak
    ) 
    if "%2" == "-ls" (
        goto helpls
    )
    goto help
)
if "%1" == "-h" (
    if "%2" == "-ex" (
        goto helpexpand
    )
    if "%2" == "-bd" (
        goto helpbreak
    ) 
    if "%2" == "-ls" (
        goto helpls
    )
    goto help
)
if "%1" == "-nt" goto neat
if "%1" == "--neat" goto neat
if "%1" == "-sbf" (
    :: verify if a second arguement is given
    if not "%2" == "" (
        set "filetype=%2"
        goto searchbyfile
    ) else (
        echo ls: Invalid Structure. no [FILETYPE] arguement given
        echo ls: Please Try "%nameonly% --help"
        goto eof
    )
)
if "%1" == "-bd" (
    if not "%2" == "" (
        set "targetfilename=%2"
        goto filebd
    ) else (
        echo ls: Invalid Structure. no [FILE] arguement given
        echo ls: Please Try "%nameonly% --help"
        goto eof
    )
)
if "%1" == "-pk" (
    if not "%2" == "" (
        set "targetdirname=%2"
        goto peekview
    ) else (
        echo ls: Invalid Structure. no [FILE] arguement given
        echo ls: Please Try "%nameonly% --help"
        goto eof
    )
)
if "%1" == "--peek" (
    if not "%2" == "" (
        set "targetdirname=%2"
        goto peekview
    ) else (
        echo ls: Invalid Structure. no [FILE] arguement given
        echo ls: Please Try "%nameonly% --help"
        goto eof
    )
)
if "%1" == "-l" (
    goto legal
)
if "%1" == "--legal" (
    goto legal
)
if "%1" == "-R" (
    goto readme
)
if "%1" == "--readme" (
    goto readme
)
if "%1" == "--update" (
    goto updatefile
)
if "%1" == "--logs" (
    goto logs
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
echo %reg% 📂 %white%%cd%%reg%
echo  %grey% │
set /a counter=0
set /a totalsize=0
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%"2^>nul') do (
    rem Get file size and creation date
    for %%A in ("%directory%\%%F") do (
        set "fileSize=%%~zA"
        set "fileCreationDate=%%~tA"
        set /a counter += 1
        if !counter! lss 10 (
            set paddedcounter=0!counter!
        ) else (
            set paddedcounter=!counter!
        )
        set /a totalsize+=!fileSize!
    )
    if errorlevel == 0 (
    echo %grey%!paddedcounter!│ %red%%currentDirName% %yellow%%%F %green%!fileSize!%grey%B %blue%!fileCreationDate:~0,10! %purple%%cd%\%%F %reg%
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
    ::set /a totalsize=!totalsize! / 2
    if !totalsize! lss 0 (
        set /a totalsize=!totalsize! * -1
    )
    set /a counter+=1
    if !counter! lss 10 (
        set paddedcounter=0!counter!
        ) else (
            set paddedcounter=!counter!
        )
    if errorlevel == 0 (
    echo %grey%!paddedcounter!│ %red%%currentDirName% %yellow%%%D %green%!dirSize!%grey%B %blue%!fileCreationDate:~0,10! %dkpurple%%cd%\%%D\ %reg%
    )
)
rem do some math
set /a gb=!totalsize! / 1000000
set /a ggb=!gb! / 1000
echo  %grey% └───%grey%TC:%green%!counter! %grey%TS:%green%!totalsize!%grey%B%reg% %grey%TS:%green%!gb!%grey%MB%reg% %grey%TS:%green%!ggb!%grey%GB%reg%
goto eof


:tree
for %%I in ("%CD%") do set "currentDirName=%%~nI"
    set "directory=%cd%"
rem List all files and directories in the specified directory
echo 📂 %white%%cd%
for /f "delims=" %%F in ('dir /b /a:-d-h "%directory%"2^>nul') do (
    echo %white%├─📄 %brightwhite%%%F%reg%
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

:invalid
echo %reg%ls: Invalid [OPTION] Arguement(s) Given
echo ls: Please Try "%nameonly% --help"
goto eof
echo.
:help 
echo.
echo Listing Your Files Inside Your Terminal 
echo Lists files inside the current directory by default
::echo Made By %green%Saaim Japanwala%reg%
echo.             
echo Usage: %nameonly% [OPTION]... [FILE]... [CODE]...
echo.
echo OPTIONS: Options are required for a customized view, else will show basic ls listing.
echo    -ex, --expand                expandable  info, shows brief information about the file (listed)
echo                                 (format for -ex: rootdirname filename filesize(B,MB,GB) editdate rootpath), (HS)
echo.
echo    -nt, --neat                  neat, neatly organizes all the files in a horizontal list
echo.
echo    -tr,  --legacy               legacy, miniature file tree/legacy (better alternative is windows "tree" command)
echo.
echo    -sbf, --searchbyfile         search by file, shows only files with the specific file extention. 
echo                                 REQUIRES FILETYPE ARG IN PLACE OF FILE ARG (.txt, .cmd, .json, etc...)
echo.
echo    -bd, --breakdown             file breakdown, shows a whole lot of information about a specific file.
echo                                 REQUIRES FILE ARG IN PLACE OF FILE ARG (please include file ext to reduce ambiguity), (HS)
echo.
echo    -pk, --peek                  lists inside a dir, without being inside.
echo                                 REQUIRES DIR NAME IN FILE
echo.
echo    -r, --recursive              recursively lists everything from current dir, down.
echo                                 larger files may take longer to process.
echo.
echo OTHER: Other commands that are for management, and other cases.
echo    -?, -h, --help   shows help menu, Usage: ls --help [OTHER]
echo                     -^> with no args, will shows general help
echo                     -^> [-a]    help about everything
echo                     -^> Specific Command Help (ls --help [-command])
echo.
echo    -R, --readme    redirects you to the readme file on www.github.com/sjapanwala
echo.
echo    -l, --legal     shows all legal information about this program.
echo.
echo    -sec            shows the error code once the program has finished execution
echo                    (input into CODE section)
echo.
echo    --logs           recent update logs
echo.
echo    --update         apply updates
echo.
echo Notes,
echo    -^> (HS) - Help Supported (-ex, -bd, -ls)
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
echo    including Root File, File Name, File Size (B, MB, GB), Date Edited, and Path
echo.
echo Model,
echo.
echo    %grey%   📂 C:\(Your Directory)
echo    %grey%   │
echo    %grey% 1 │ %red%Root Folder%reg% %yellow%File Name%reg% %green%File Size%reg% %blue%Date Created/Edited%reg% %purple%Path (file)%reg%
echo    %grey% 2 │ %red%Root Folder%reg% %yellow%File Name%reg% %green%File Size%reg% %blue%Date Created/Edited%reg% %dkpurple%Path (dir)%reg%
echo    %grey%   └───TC:%green%(Total Content) %grey%TS:%green%(Total Size Bytes) %grey%TS:%green%(Total Size MegaBytes)%reg% %grey%TS:%green%(Total Size GigaBytes)%reg%
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
goto eof

:helpls
echo Usage: ls (blank)
echo.
echo Description,
echo    basic file listing, lists files and directories in seperate colour highlighting. (default, file=grey, dir=dkblue)
echo.
echo Model,
echo.
echo    %grey%file_one  file_two  file_three  %dkblue%dir_one  dir_two  dir_three%reg%
goto eof
:peekview
rem Set current directory name
set "directory=%cd%\%targetdirname%"
if not exist %directory% echo No Directory Found && goto eof


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

:legal
echo Credits,
echo    -^> Primary Developer: %green%Saaim Japanwala %reg%
echo    -^> With Inspiration From: %green%Richard Stallman %reg%and %green%David MacKenzie%reg%
echo.
echo Licensing,
echo MIT License
echo. 
echo Copyright (c) 2024 Saaim Japanwala
echo. 
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo. 
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo. 
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo.
goto eof
:readme
start https://github.com/sjapanwala/ls-for-win
goto eof

:recur
set /a totalcount=0
set /a counterdir=0
set "startDir=%cd%"

REM Call the recursive function
call :listFiles "%startDir%"
exit /b

:listFiles
set /a counterdir+=1
set "currentDir=%~1"
echo %grey%!counterdir! %reg%^| %dkpurple%%currentDir%%reg%
for %%I in ("%currentDir%") do (
    set direpre=%%~nI
)
REM Use a for loop to iterate through files and directories
if not defined direpre (
    set direpre=root
)
for %%I in ("%CD%") do set "currentDirName=%%~nI"
(for /f "delims=" %%A in ('dir /b /a-d "%currentDir%"') do set /a totalcount +=1 && echo %grey%!counterdir! %reg%^| %red%%currentDirName%  %yellow%%direpre% %green%%%A%reg%)2>nul
for /f "delims=" %%D in ('dir /b /ad "%currentDir%"') do set direpre=%currentDir%\%%D && call :listFiles "%currentDir%\%%D" 
goto eof

:updatefile
set connection=False
PING -n 1 1.1.1.1 | FIND "TTL=">nul && set connection=True
echo Update Current Version?
echo -^> This Will Apply To %currentFile%
echo -^> Connection: %connection%
set choice=
set /p choice=Continue? (y/n): 
if %choice%==Y goto updatefileapply
if %choice%==y goto updatefileapply
if %choice%==n goto eof
if %choice%==N goto eof
goto updatefile
:updatefileapply
set updaterawurl=https://raw.githubusercontent.com/sjapanwala/ls-for-win/main/ls.cmd
curl -s %updaterawurl%>%currentFile%
goto eof

:logs
echo UPDATE %version%
echo.
echo %green%Added Recursive Listing,%reg%
echo - recursivly lists from the current directory downwards.
echo    -^> Usage: ls -r
echo    -^> Usage: ls --recursive
echo.
echo %green%Added Peek View,%reg%
echo - peeks through a chosen directory without it being the current directory.
echo    -^> Usage: ls -pk [DIRECTORY]
echo    -^> Usage: ls --peek [DIRECTORY]
echo.
echo %green%Added In Program Updates,%reg%
echo - update the program through the terminal.
echo    -^> Usage: ls --update
echo.
echo %green%Added In Program Logs,%reg%
echo - access the updates and new featres. (you are here right now)
echo    -^> Usage: ls --logs
echo.
echo %blue%Minor Updates%reg%   
echo --readme, -R -^> access readme
echo --legal, -l  -^> access legal and Credits
echo -sec         -^> show error codes
echo.
goto eof

:eof
if "%1" == -sec (
    echo exit code: %errorlevel%
)
if "%2" == "-sec" (
    echo exit code: %errorlevel%
)
if "%3" == "-sec" (
    echo exit code: %errorlevel%
)
