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
:start_file
if "%1" == "-ex" goto expand
if "%1" == "-tr" goto tree
if "%1" == "" goto basic
if "%1" == "-help" goto help
if "%1" == "-nt" goto neat
if "%1" == "-gr" goto graphical


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
echo  %grey%└───%grey%TC:%green%!counter! %grey%TS:%green%!totalsize!%grey%B%reg% %grey%TS:%green%!gb!GB
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
echo %reg%Invalid Arguements Given
echo Please Try "fls -help"
goto eof
echo.
:help 
echo.
echo ╔═╗╦  ╔═╗     ╦ ╦╔═╗╦  ╔═╗
echo ╠╣ ║  ╚═╗  ───╠═╣║╣ ║  ╠═╝
echo ╚  ╩═╝╚═╝     ╩ ╩╚═╝╩═╝╩   
echo.
echo Listing Your Files Inside Your Terminal 
echo Made By %green%Saaim Japanwala%reg%
echo %grey%NOTE: Some Features Will Work With Nerd Font, And Themes With Differnt Colours
echo And Variations Of Colours. %reg%
echo.               
echo ARGS
echo fls -help → shows a help and description menu
echo fls       → basic listing (like linux)
echo fls -ex   → expands and shows info you want to know (filecount  dirname  name  size  lastwrite  directory)
echo fls -tr   → shows a simple legacy list (tree)
echo fls -nt   → neatly lists the files
echo fls -gr   → graphical menu
goto eof
:eof
