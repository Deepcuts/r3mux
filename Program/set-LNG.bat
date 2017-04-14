@ECHO OFF
SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion

REM Using ffmpeg.exe from https://ffmpeg.zeranoe.com/builds/
REM Using cecho.exe from https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files
REM Using mkvalidator.exe from https://www.matroska.org/downloads/mkvalidator.html


REM You should only modify settings.ini


REM ##########################
REM # Import Settings START #
REM ##########################

for /f "tokens=1,2 delims==" %%a in (settings.ini) do (
if %%a==INPUT set INPUT=%%b
if %%a==OUTPUT set OUTPUT=%%b
if %%a==FFMPEG set FFMPEG=%%b
if %%a==MKVALIDATOR set MKVALIDATOR=%%b
if %%a==CECHO set CECHO=%%b
if %%a==OVERWRITE set OVERWRITE=%%b
if %%a==BEEP-ERR set BEEP-ERR=%%b
if %%a==BEEP-OK set BEEP-OK=%%b
if %%a==LOGLEVEL set LOGLEVEL=%%b
if %%a==A-LNG set A-LNG=%%b
if %%a==IN-EXT set IN-EXT=%%b
if %%a==OUT-EXT set OUT-EXT=%%b
if %%a==A-CODEC set A-CODEC=%%b
if %%a==A-BIT set A-BIT=%%b
if %%a==A-CHAN set A-CHAN=%%b
)

REM #######################
REM # Import Settings END #
REM #######################

Color 0A
mode con cols=140 lines=50


if NOT exist %FFMPEG% goto :CRITICAL
if NOT exist %MKVALIDATOR% goto :CRITICAL
if NOT exist %CECHO% goto :CRITICAL

echo Input   folder: %INPUT%
echo Output  folder: %OUTPUT%
set NumFiles=0
set /a NumXX=0
set NumError=0
set NumDup=0
set NumOK=0
for %%A in (%INPUT%\*.%IN-EXT%) do set /a NumFiles+=1
echo Number of %IN-EXT%s: %NumFiles%
echo Job settings  : ReMuxing %IN-EXT% to %OUT-EXT% with %A-LNG% %A-FORMAT% %A-BIT% %A-CHAN% channels audio
echo.


if %NumFiles%==0 goto :NoJobs

if "%OVERWRITE%"=="-y" (set MSG=ffmpeg.exe will overwrite file)
if "%OVERWRITE%"=="-n" (set MSG=ffmpeg.exe will skip file)


echo Checking for duplicates in %OUTPUT%
for %%F in ("%INPUT%\*.%IN-EXT%") do (title Checking for duplicates & if exist %OUTPUT%\%%~nF.%OUT-EXT% set /a NumDup+=1 & %CECHO% {red}%%~nF.%OUT-EXT% already exists. %MSG%{#}{\n})
if %NumDup%==0 echo No duplicates found
if Not %NumDup%==0 %CECHO% {red}Found %NumDup% duplicates{#}{\n}
echo.
echo.
echo Begin validation...
for %%F in ("%INPUT%\*.mkv") do (title Validating %%~nF & set /p "=Validating > %%~nF.mkv..." <nul & %MKVALIDATOR% --quiet --no-warn "%INPUT%\%%~nF.mkv" 2> nul && (echo Success) || (%CECHO% {red}Error!{#}{\n} & set /a NumError+=1 & ren "%INPUT%\%%~nF.mkv" "%%~nF.mkv.BAD" & %CECHO% {red}mkvalidator.exe reported an error on file %%~nF.mkv. Renamed to *.BAD{#}{\n}))
if %NumError%==0 echo No errors found
if Not %NumError%==0 %CECHO% {red}Found %NumError% errors{#}{\n}
echo.
echo.
if %NumFiles%==%NumError% goto :NoJobsError
set /a NumFiles=NumFiles-NumError
echo Begin ReMuxing... 
for %%F in ("%INPUT%\*.%IN-EXT%") do (title ReMuxing %%~nF & set /a NumXX=NumXX+1 & set /p "=Job !NumXX! of %NumFiles% > %%~nF.%IN-EXT%..." <nul & %FFMPEG% %OVERWRITE% %LOGLEVEL% -i "%%F" -vcodec copy -c:a copy -map_metadata -1 -metadata:s:a:0 language=%A-LNG% -map_chapters -1 -movflags +faststart "%OUTPUT%\%%~nF.%OUT-EXT%" & (echo Success & set /a NumOK+=1) || (%CECHO% {red}Error!{#}{\n} & set /a NumError+=1 & %CECHO% {red}ffmpeg.exe reported an error on file %%~nF.%IN-EXT%{#}{\n}))


if "%NumError%"=="0" (
	goto :EXIT
) else (
   goto :ERR
) 

:NoJobs
echo.
echo.
%CECHO% {red}No %IN-EXT% files found in %INPUT% folder{#}{\n}
echo.
echo.
echo Window wil auto-close in 8 seconds...
timeout /t 8 > NUL
exit

:NoJobsError
echo.
echo.
%CECHO% {red}All %IN-EXT% files found in %INPUT% folder failed validation by mkvalidator.exe{#}{\n}
echo.
echo.
echo Window wil auto-close in 8 seconds...
timeout /t 8 > NUL
exit

:ERR
echo.
echo.
%CECHO% {red}Errors were reported by ffmpeg.exe{#}{\n}
if %BEEP-ERR%==1 %CECHO% {\u07 \u07 \u07 \u07}
%CECHO% {0A}Job status: {red}Error=%NumError% {0A}OK=%NumOK%{#}{\n}
echo.
echo.
PAUSE
goto :EXIT1

:EXIT
echo.
echo.
echo Successful jobs: %NumOK%
echo.
echo.
echo Window wil auto-close in 8 seconds...
if %BEEP-OK%==1 %CECHO% {\u07 \u07}
timeout /t 8 > NUL
exit

:CRITICAL
Color 0C
echo Critical files are missing. Program cannot continue.
echo Check the paths set in settings.ini
echo.
if NOT exist %FFMPEG% echo ffmpeg.exe is missing from tools folder
if NOT exist %MKVALIDATOR% echo mkvalidator.exe is missing from tools folder
if NOT exist %CECHO% echo cecho.exe is missing from tools folder
echo.
echo Using ffmpeg.exe from https://ffmpeg.zeranoe.com/builds/
echo Using mkvalidator.exe from https://www.matroska.org/downloads/mkvalidator.html
echo Using cecho.exe from https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files
PAUSE
goto :EXIT1

:EXIT1
exit
