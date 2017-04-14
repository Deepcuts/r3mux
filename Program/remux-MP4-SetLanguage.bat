@ECHO OFF
SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion

Color 0A
mode con cols=140 lines=50

REM ##################
REM # Settings START #
REM ##################

REM # Input folder path
set INPUT=D:\_Video_\Batch\Jobs

REM # Output folder path
set OUTPUT=D:\_Video_\Batch\Completed

REM # Path to ffmpeg.exe
REM # Default tools\ffmpeg.exe
set FFMPEG=tools\ffmpeg.exe

REM # Path to cecho.exe
REM # Default tools\cecho.exe 
set CECHO=tools\cecho.exe

REM # -y tells ffmpeg.exe to overwrite destination file with the same name
REM # If you set -y and a destination file exists, ffmeg will report an error ONLY if the input file is damaged
REM # -n tells ffmpeg.exe to skip destination file with the same name
REM # If you set -n and a destination file exists, ffmeg will report an error on the file even if the the input file is OK
REM # Default -y
set OVERWRITE=-y

REM # Beep on errors after all files are ReMuxed
REM # Default 1
set BEEP-ERR=1

REM # Beep on success without errors after all files are ReMuxed
REM # Default 0
set BEEP-OK=0


REM # -loglevel panic tells ffmpeg.exe to be quiet. Leave empty for more info. 
REM # Default -loglevel panic
set LOGLEVEL=-loglevel panic

REM # Audio language - 3 characters format
set A-LNG=eng

REM # Input extension to scan and ReMux
set IN-EXT=mp4

REM # Output extension to ReMux to
set OUT-EXT=mp4

REM # Audio format
REM # Default aac
set A-FORMAT=aac

REM # Audio bitrate
REM # Default 128k
set A-BIT=128k

REM # Audio channels
REM # Default 2
set A-CHAN=2

REM ################
REM # Settings END #
REM ################


if NOT exist %FFMPEG% set FFMPEG-ERR=1 
if NOT exist %CECHO% (set CECHO-ERR=1 & goto :CRITICAL)


echo Working folder: %INPUT%
echo Output  folder: %OUTPUT%
echo Settings      : ReMuxing %IN-EXT% to %OUT-EXT% with %A-LNG% %A-FORMAT% %A-BIT% %A-CHAN% channels audio
set NumFiles=0
set NumError=0
for %%A in (%INPUT%\*.%IN-EXT%) do set /a NumFiles+=1
echo # of %IN-EXT% Files: %NumFiles%
echo.

if "%OVERWRITE%"=="-y" (set MSG=Overwriting file)
if "%OVERWRITE%"=="-n" (set MSG=Skipping file)

for %%F in ("%INPUT%\*.%IN-EXT%") do (if exist %OUTPUT%\%%~nF.%OUT-EXT% %CECHO% {red}%%~nF.%OUT-EXT% already exists. %MSG%{#}{\n})
echo.
for %%F in ("%INPUT%\*.%IN-EXT%") do (title ReMuxing %%~nF & set /p "=ReMuxing> %%~nF.%IN-EXT%..." <nul & %FFMPEG% %OVERWRITE% %LOGLEVEL% -i "%%F" -vcodec copy -c:a copy -map_metadata -1 -metadata:s:a:0 language=%A-LNG% -map_chapters -1 -movflags +faststart "%OUTPUT%\%%~nF.%OUT-EXT%" && (echo Success) || (%CECHO% {red}Error!{#}{\n} & set /a NumError+=1 & %CECHO% {red}ffmpeg.exe reported an error on file %%~nF.%IN-EXT%{#}{\n}))


if "%NumError%"=="0" (
	goto :EXIT
) else (
   goto :ERR
) 

:ERR
echo.
echo.
%CECHO% {red}Errors were reported by the encoder!{#}{\n}
if %BEEP-ERR%==1 %CECHO% {\u07 \u07 \u07 \u07}
set /a NumOK=%NumFiles%-%NumError%
%CECHO% {0A}Job status: {red}Error=%NumError% {0A}OK=%NUmOK%{#}{\n}
PAUSE
goto :EXIT1

:EXIT
echo.
echo.
set /a NumOK=%NumFiles%-%NumError%
echo Successful jobs: %NumOK% jobs
echo Window wil auto-close in 5 seconds...
if %BEEP-OK%==1 %CECHO% {\u07 \u07}
timeout /t 5 > NUL

:CRITICAL
echo Critical files are missing!
if %FFMPEG-ERR%==1 echo Critical error: ffmpeg.exe not found. Configure the correct path for ffmpeg.exe!
if %CECHO-ERR%==1 echo Critical error: checho.exe not found. Configure the correct path for cecho.exe
PAUSE
goto :EXIT1

:EXIT1