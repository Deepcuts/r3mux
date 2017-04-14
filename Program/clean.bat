@echo off
CD ../Completed
for /f "delims=" %%a in ('dir /a:-d /o:n /b') do call :next "%%a"
GOTO:EOF
:next
set "newname=%~nx1"

set "newname=%newname:}= %"
set "newname=%newname:{= %"
set "newname=%newname:]= %"
set "newname=%newname:[= %"
set "newname=%newname:;= %"
set "newname=%newname:.= %"
set "newname=%newname:-= %"
set "newname=%newname:720p= %"
set "newname=%newname:1080p= %"
set "newname=%newname:x264= %"
set "newname=%newname:H264= %"
set "newname=%newname:DD5= %"
set "newname=%newname:HDTV= %"
set "newname=%newname:WebRip= %"
set "newname=%newname:Web-DL= %"
set "newname=%newname:YTS= %"
set "newname=%newname:eztv= %"
set "newname=%newname:BluRay= %"
set "newname=%newname:  =%"
set "newname=%newname:mp4=.mp4%"
set "newname=%newname: mp4=.mp4%"


ren %1 "%newname%

